module Authlogic
  module Session # :nodoc:
    # = Base
    #
    # This is the muscle behind Authlogic. For detailed information on how to use this please refer to the README. For detailed method explanations see below.
    class Base
      include Config
      
      class << self
        attr_accessor :methods_configured
        
        # Returns true if a controller have been set and can be used properly. This MUST be set before anything can be done. Similar to how ActiveRecord won't allow you to do anything
        # without establishing a DB connection. In your framework environment this is done for you, but if you are using Authlogic outside of your frameword, you need to assign a controller
        # object to Authlogic via Authlogic::Session::Base.controller = obj.
        def activated?
          !controller.blank?
        end
        
        def controller=(value) # :nodoc:
          Thread.current[:authlogic_controller] = value
        end
        
        def controller # :nodoc:
          Thread.current[:authlogic_controller]
        end
        
        # A convenince method. The same as:
        #
        #   session = UserSession.new
        #   session.create
        def create(*args, &block)
          session = new(*args)
          session.save(&block)
        end
        
        # Same as create but calls create!, which raises an exception when authentication fails
        def create!(*args)
          session = new(*args)
          session.save!
        end
        
        # A convenience method for session.find_record. Finds your session by parameters, then session, then cookie, and finally by basic http auth.
        # This is perfect for persisting your session:
        #
        #   helper_method :current_user_session, :current_user
        #
        #   def current_user_session
        #     return @current_user_session if defined?(@current_user_session)
        #     @current_user_session = UserSession.find
        #   end
        #
        #   def current_user
        #     return @current_user if defined?(@current_user)
        #     @current_user = current_user_session && current_user_session.user
        #   end
        #
        # Accepts a single parameter as the id, to find session that you marked with an id:
        #
        #   UserSession.find(:secure)
        #
        # See the id method for more information on ids.
        def find(id = nil)
          args = [id].compact
          session = new(*args)
          return session if session.find_record
          nil
        end
        
        # The name of the class that this session is authenticating with. For example, the UserSession class will authenticate with the User class
        # unless you specify otherwise in your configuration.
        def klass
          @klass ||=
            if klass_name
              klass_name.constantize
            else
              nil
            end
        end
        
        # Same as klass, just returns a string instead of the actual constant.
        def klass_name
          @klass_name ||= 
            if guessed_name = name.scan(/(.*)Session/)[0]
              @klass_name = guessed_name[0]
            end
        end
      end
    
      attr_accessor :new_session
      attr_reader :record, :unauthorized_record
      attr_writer :authenticating_with, :id, :persisting
    
      # You can initialize a session by doing any of the following:
      #
      #   UserSession.new
      #   UserSession.new(:login => "login", :password => "password", :remember_me => true)
      #   UserSession.new(User.first, true)
      #
      # If a user has more than one session you need to pass an id so that Authlogic knows how to differentiate the sessions. The id MUST be a Symbol.
      #
      #   UserSession.new(:my_id)
      #   UserSession.new({:login => "login", :password => "password", :remember_me => true}, :my_id)
      #   UserSession.new(User.first, true, :my_id)
      #
      # For more information on ids see the id method.
      #
      # Lastly, the reason the id is separate from the first parameter hash is becuase this should be controlled by you, not by what the user passes.
      # A user could inject their own id and things would not work as expected.
      def initialize(*args)
        raise NotActivated.new(self) unless self.class.activated?
        
        create_configurable_methods!
        
        self.id = args.pop if args.last.is_a?(Symbol)
        
        if args.first.is_a?(Hash)
          self.credentials = args.first
        elsif !args.first.blank? && args.first.class < ::ActiveRecord::Base
          self.unauthorized_record = args.first
          self.remember_me = args[1] if args.size > 1
        end
      end
      
      # A flag for how the user is logging in. Possible values:
      #
      # * <tt>:password</tt> - username and password
      # * <tt>:unauthorized_record</tt> - an actual ActiveRecord object
      #
      # By default this is :password
      def authenticating_with
        @authenticating_with ||= :password
      end
      
      # Returns true if logging in with credentials. Credentials mean username and password.
      def authenticating_with_password?
        authenticating_with == :password
      end
      
      # Returns true if logging in with an unauthorized record
      def authenticating_with_unauthorized_record?
        authenticating_with == :unauthorized_record
      end
      alias_method :authenticating_with_record?, :authenticating_with_unauthorized_record?
      
      # Your login credentials in hash format. Usually {:login => "my login", :password => "<protected>"} depending on your configuration.
      # Password is protected as a security measure. The raw password should never be publicly accessible.
      def credentials
        {login_field => send(login_field), password_field => "<Protected>"}
      end
      
      # Lets you set your loging and password via a hash format. This is "params" safe. It only allows for 3 keys: your login field name, password field name, and remember me.
      def credentials=(values)
        return if values.blank? || !values.is_a?(Hash)
        values.symbolize_keys!
        values.each do |field, value|
          next if value.blank?
          send("#{field}=", value)
        end
      end
      
      # Resets everything, your errors, record, cookies, and session. Basically "logs out" a user.
      def destroy
        errors.clear
        @record = nil
        true
      end
      
      # The errors in Authlogic work JUST LIKE ActiveRecord. In fact, it uses the exact same ActiveRecord errors class. Use it the same way:
      #
      # === Example
      #
      #  class UserSession
      #    before_validation :check_if_awesome
      #
      #    private
      #      def check_if_awesome
      #        errors.add(:login, "must contain awesome") if login && !login.include?("awesome")
      #        errors.add_to_base("You must be awesome to log in") unless record.awesome?
      #      end
      #  end
      def errors
        @errors ||= Errors.new(self)
      end
      
      # Attempts to find the record by params, then session, then cookie, and finally basic http auth. See the class level find method if you are wanting to use this to persist your session.
      def find_record
        if record
          self.new_session = false
          return record
        end
        
        find_with.each do |find_method|
          if send("valid_#{find_method}?")
            self.new_session = false
            
            if record.class.column_names.include?("last_request_at") && (record.last_request_at.blank? || last_request_at_threshold.to_i.seconds.ago >= record.last_request_at)
              record.last_request_at = Time.now
              record.save_without_session_maintenance(false)
            end
            
            return record
          end
        end
        nil
      end
      
      # Allows you to set a unique identifier for your session, so that you can have more than 1 session at a time. A good example when this might be needed is when you want to have a normal user session
      # and a "secure" user session. The secure user session would be created only when they want to modify their billing information, or other sensitive information. Similar to me.com. This requires 2
      # user sessions. Just use an id for the "secure" session and you should be good.
      #
      # You can set the id during initialization (see initialize for more information), or as an attribute:
      #
      #   session.id = :my_id
      #
      # Just be sure and set your id before you save your session.
      #
      # Lastly, to retrieve your session with the id check out the find class method.
      def id
        @id
      end
      
      def inspect # :nodoc:
        details = {}
        case authenticating_with
        when :unauthorized_record
          details[:unauthorized_record] = "<protected>"
        else
          details[login_field.to_sym] = send(login_field)
          details[password_field.to_sym] = "<protected>"
        end
        "#<#{self.class.name} #{details.inspect}>"
      end
      
      # Similar to ActiveRecord's new_record? Returns true if the session has not been saved yet.
      def new_session?
        new_session != false
      end
      
      def persisting # :nodoc:
        return @persisting if defined?(@persisting)
        @persisting = true
      end
      
      # Returns true if the session is being persisted. This is set to false if the session was found by the single_access_token, since logging in via a single access token should not remember the user in the
      # session or the cookie.
      def persisting?
        persisting == true
      end
      
      def remember_me # :nodoc:
        return @remember_me if defined?(@remember_me)
        @remember_me = self.class.remember_me
      end
      
      # Accepts a boolean as a flag to remember the session or not. Basically to expire the cookie at the end of the session or keep it for "remember_me_until".
      def remember_me=(value)
        @remember_me = value
      end
      
      # Allows users to be remembered via a cookie.
      def remember_me?
        remember_me == true || remember_me == "true" || remember_me == "1"
      end
      
      # When to expire the cookie. See remember_me_for configuration option to change this.
      def remember_me_until
        return unless remember_me?
        remember_me_for.from_now
      end
      
      # Creates / updates a new user session for you. It does all of the magic:
      #
      # 1. validates
      # 2. sets session
      # 3. sets cookie
      # 4. updates magic fields
      def save(&block)
        result = nil
        if valid?
          record.login_count = (record.login_count.blank? ? 1 : record.login_count + 1) if record.respond_to?(:login_count)
          
          if record.respond_to?(:current_login_at)
            record.last_login_at = record.current_login_at if record.respond_to?(:last_login_at)
            record.current_login_at = Time.now
          end
          
          if record.respond_to?(:current_login_ip)
            record.last_login_ip = record.current_login_ip if record.respond_to?(:last_login_ip)
            record.current_login_ip = controller.request.remote_ip
          end
          
          record.save_without_session_maintenance(false)
          
          self.new_session = false
          result = self
        else
          result = false
        end
        
        yield result if block_given?
        result
      end
      
      # Same as save but raises an exception when authentication fails
      def save!
        result = save
        raise SessionInvalid.new(self) unless result
        result
      end
      
      # This lets you create a session by passing a single object of whatever you are authenticating. Let's say User. By passing a user object you are vouching for this user and saying you can guarantee
      # this user is who he says he is, create a session for him.
      #
      # This is how persistence works in Authlogic. Authlogic grabs your cookie credentials, finds a user by those credentials, and then vouches for that user and creates a session. You can do this for just about
      # anything, which comes in handy for those unique authentication methods. Do what you need to do to authenticate the user, guarantee he is who he says he is, then pass the object here. Authlogic will do its
      # magic: create a session and cookie. Now when the user refreshes their session will be persisted by their session and cookie.
      def unauthorized_record=(value)
        self.authenticating_with = :unauthorized_record
        @unauthorized_record = value
      end
      
      # Returns if the session is valid or not. Basically it means that a record could or could not be found. If the session is valid you will have a result when calling the "record" method. If it was unsuccessful
      # you will not have a record.
      def valid?
        errors.clear
        if valid_credentials?
          validate
          valid_record?
          return true if errors.empty?
        end
        
        self.record = nil
        false
      end
      
      # Tries to validate the session from information from a basic http auth, if it was provided.
      def valid_http_auth?
        controller.authenticate_with_http_basic do |login, password|
          if !login.blank? && !password.blank?
            send("#{login_field}=", login)
            send("#{password_field}=", password)
            return valid?
          end
        end
        
        false
      end
      
      # Overwite this method to add your own validation, or use callbacks: before_validation, after_validation
      def validate
      end
      
      private
        def controller
          self.class.controller
        end
        
        # The goal with Authlogic is to feel as natural as possible. As a result, this method creates methods on the fly
        # based on the configuration set. By default the configuration is based off of the columns names in the authenticating
        # model. Thus allowing you to call user_session.username instead of user_session.login if you have a username column
        # instead of a login column. Since class configuration can change during initialization it makes the most sense to enforce
        # this configuration during the first initialization. At this point, all configuration should be set.
        #
        # Lastly, each method is defined individually to allow the user to provide their own "custom" method and this makes sure
        # we don't replace their method.
        def create_configurable_methods!
          return if self.class.methods_configured == true
          
          self.class.send(:alias_method, klass_name.demodulize.underscore.to_sym, :record)
          self.class.send(:attr_writer, login_field) if !respond_to?("#{login_field}=")
          self.class.send(:attr_reader, login_field) if !respond_to?(login_field)
          self.class.send(:attr_writer, password_field) if !respond_to?("#{password_field}=")
          self.class.send(:define_method, password_field) {} if !respond_to?(password_field)
          
          self.class.class_eval <<-"end_eval", __FILE__, __LINE__
            def #{login_field}_with_authentication_flag=(value)
              self.authenticating_with = :password
              self.#{login_field}_without_authentication_flag = value
            end
            alias_method_chain :#{login_field}=, :authentication_flag
            
            def #{password_field}_with_authentication_flag=(value)
              self.authenticating_with = :password
              self.#{password_field}_without_authentication_flag = value
            end
            alias_method_chain :#{password_field}=, :authentication_flag
            
            private
              # The password should not be accessible publicly. This way forms using form_for don't fill the password with the attempted password. The prevent this we just create this method that is private.
              def protected_#{password_field}
                @#{password_field}
              end
          end_eval
          
          self.class.methods_configured = true
        end
        
        def klass
          self.class.klass
        end
      
        def klass_name
          self.class.klass_name
        end
        
        def record=(value)
          @record = value
        end
        
        def search_for_record(method, value)
          klass.send(method, value)
        end
        
        def valid_credentials?
          unchecked_record = nil
          
          case authenticating_with
          when :password
            errors.add(login_field, login_blank_message) if send(login_field).blank?
            errors.add(password_field, password_blank_message) if send("protected_#{password_field}").blank?
            return false if errors.count > 0
            
            unchecked_record = search_for_record(find_by_login_method, send(login_field))
            
            if unchecked_record.blank?
              errors.add(login_field, login_not_found_message)
              return false
            end
            
            unless unchecked_record.send(verify_password_method, send("protected_#{password_field}"))
              errors.add(password_field, password_invalid_message)
              return false
            end
            
            self.record = unchecked_record
          when :unauthorized_record
            unchecked_record = unauthorized_record
            
            if unchecked_record.blank?
              errors.add_to_base("You can not login with a blank record.")
              return false
            end
            
            if unchecked_record.new_record?
              errors.add_to_base("You can not login with a new record.")
              return false
            end
            
            self.record = unchecked_record
          end
          
          true
        end
        
        def valid_record?
          return true if disable_magic_states?
          [:active, :approved, :confirmed].each do |required_status|
            if record.respond_to?("#{required_status}?") && !record.send("#{required_status}?")
              errors.add_to_base(send("not_#{required_status}_message"))
              return false
            end
          end
          true
        end
    end
  end
end