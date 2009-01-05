module Authlogic
  module Session
    module Config # :nodoc:
      def self.included(klass)
        klass.extend(ClassMethods)
        klass.send(:include, InstanceMethods)
      end
      
      # = Session Config
      #
      # This deals with configuration for your session. If you are wanting to configure your model please look at Authlogic::ORMAdapters::ActiveRecordAdapter::ActsAsAuthentic::Config
      #
      # Configuration for your session is simple. The configuration options are just class methods. Just put this in your config/initializers directory
      #
      #   UserSession.configure do |config|
      #     config.authenticate_with = User
      #     # ... more configuration
      #   end
      #
      # or you can set your configuration in the session class directly:
      #
      #   class UserSession < Authlogic::Session::Base
      #     authenticate_with User
      #     # ... more configuration
      #   end
      #
      # You can also access the values in the same fashion:
      #
      #   UserSession.authenticate_with
      #
      # See the methods belows for all configuration options.
      module ClassMethods
        # Lets you change which model to use for authentication.
        #
        # * <tt>Default:</tt> inferred from the class name. UserSession would automatically try User
        # * <tt>Accepts:</tt> an ActiveRecord class
        def authenticate_with(klass)
          @klass_name = klass.name
          @klass = klass
        end
        alias_method :authenticate_with=, :authenticate_with
        
        # Convenience method that lets you easily set configuration, see examples above
        def configure
          yield self
        end
        
        # The name of the cookie or the key in the cookies hash. Be sure and use a unique name. If you have multiple sessions and they use the same cookie it will cause problems.
        # Also, if a id is set it will be inserted into the beginning of the string. Exmaple:
        #
        #   session = UserSession.new
        #   session.cookie_key => "user_credentials"
        #   
        #   session = UserSession.new(:super_high_secret)
        #   session.cookie_key => "super_high_secret_user_credentials"
        #
        # * <tt>Default:</tt> "#{klass_name.underscore}_credentials"
        # * <tt>Accepts:</tt> String
        def cookie_key(value = nil)
          if value.nil?
            read_inheritable_attribute(:cookie_key) || cookie_key("#{klass_name.underscore}_credentials")
          else
            write_inheritable_attribute(:cookie_key, value)
          end
        end
        alias_method :cookie_key=, :cookie_key
        
        # Set this to true if you want to disable the checking of active?, approved?, and confirmed? on your record. This is more or less of a
        # convenience feature, since 99% of the time if those methods exist and return false you will not want the user logging in. You could
        # easily accomplish this same thing with a before_validation method or other callbacks.
        #
        # * <tt>Default:</tt> false
        # * <tt>Accepts:</tt> Boolean
        def disable_magic_states(value = nil)
          if value.nil?
            read_inheritable_attribute(:disable_magic_states)
          else
            write_inheritable_attribute(:disable_magic_states, value)
          end
        end
        alias_method :disable_magic_states=, :disable_magic_states
        
        # Authlogic tries to validate the credentials passed to it. One part of validation is actually finding the user and making sure it exists. What method it uses the do this is up to you.
        #
        # Let's say you have a UserSession that is authenticating a User. By default UserSession will call User.find_by_login(login). You can change what method UserSession calls by specifying it here. Then
        # in your User model you can make that method do anything you want, giving you complete control of how users are found by the UserSession.
        #
        # Let's take an example: You want to allow users to login by username or email. Set this to the name of the class method that does this in the User model. Let's call it "find_by_username_or_email"
        #
        #   class User < ActiveRecord::Base
        #     def self.find_by_username_or_email(login)
        #       find_by_username(login) || find_by_email(login)
        #     end
        #   end
        #
        # * <tt>Default:</tt> "find_by_#{login_field}"
        # * <tt>Accepts:</tt> Symbol or String
        def find_by_login_method(value = nil)
          if value.nil?
            read_inheritable_attribute(:find_by_login_method) || find_by_login_method("find_by_#{login_field}")
          else
            write_inheritable_attribute(:find_by_login_method, value)
          end
        end
        alias_method :find_by_login_method=, :find_by_login_method
        
        # Calling UserSession.find tries to find the user session by session, then cookie, then params, and finally by basic http auth.
        # This option allows you to change the order or remove any of these.
        #
        # * <tt>Default:</tt> [:params, :session, :cookie, :http_auth]
        # * <tt>Accepts:</tt> Array, and can only use any of the 3 options above
        def find_with(*values)
          if values.blank?
            read_inheritable_attribute(:find_with) || find_with(:params, :session, :cookie, :http_auth)
          else
            values.flatten!
            write_inheritable_attribute(:find_with, values)
          end
        end
        alias_method :find_with=, :find_with
        
        # Every time a session is found the last_request_at field for that record is updatd with the current time, if that field exists. If you want to limit how frequent that field is updated specify the threshold
        # here. For example, if your user is making a request every 5 seconds, and you feel this is too frequent, and feel a minute is a good threashold. Set this to 1.minute. Once a minute has passed in between
        # requests the field will be updated.
        #
        # * <tt>Default:</tt> 0
        # * <tt>Accepts:</tt> integer representing time in seconds
        def last_request_at_threshold(value = nil)
          if value.nil?
            read_inheritable_attribute(:last_request_at_threshold) || last_request_at_threshold(0)
          else
            write_inheritable_attribute(:last_request_at_threshold, value)
          end
        end
        alias_method :last_request_at_threshold=, :last_request_at_threshold
        
        # The error message used when the login is left blank.
        #
        # * <tt>Default:</tt> "can not be blank"
        # * <tt>Accepts:</tt> String
        def login_blank_message(value = nil)
          if value.nil?
            read_inheritable_attribute(:login_blank_message) || login_blank_message("can not be blank")
          else
            write_inheritable_attribute(:login_blank_message, value)
          end
        end
        alias_method :login_blank_message=, :login_blank_message
        
        # The error message used when the login could not be found in the database.
        #
        # * <tt>Default:</tt> "does not exist"
        # * <tt>Accepts:</tt> String
        def login_not_found_message(value = nil)
          if value.nil?
            read_inheritable_attribute(:login_not_found_message) || login_not_found_message("does not exist")
          else
            write_inheritable_attribute(:login_not_found_message, value)
          end
        end
        alias_method :login_not_found_message=, :login_not_found_message
        
        # The name of the method you want Authlogic to create for storing the login / username. Keep in mind this is just for your
        # Authlogic::Session, if you want it can be something completely different than the field in your model. So if you wanted people to
        # login with a field called "login" and then find users by email this is compeltely doable. See the find_by_login_method configuration
        # option for more details.
        #
        # * <tt>Default:</tt> Uses the configuration option in your model: User.acts_as_authentic_config[:login_field]
        # * <tt>Accepts:</tt> Symbol or String
        def login_field(value = nil)
          if value.nil?
            read_inheritable_attribute(:login_field) || login_field(klass.acts_as_authentic_config[:login_field])
          else
            write_inheritable_attribute(:login_field, value)
          end
        end
        alias_method :login_field=, :login_field
        
        # The error message used when the record returns false to active?
        #
        # * <tt>Default:</tt> "Your account is not active"
        # * <tt>Accepts:</tt> String
        def not_active_message(value = nil)
          if value.nil?
            read_inheritable_attribute(:not_active_message) || not_active_message("Your account is not active")
          else
            write_inheritable_attribute(:not_active_message, value)
          end
        end
        alias_method :not_active_message=, :not_active_message
        
        # The error message used when the record returns false to approved?
        #
        # * <tt>Default:</tt> "Your account is not approved"
        # * <tt>Accepts:</tt> String
        def not_approved_message(value = nil)
          if value.nil?
            read_inheritable_attribute(:not_approved_message) || not_approved_message("Your account is not approved")
          else
            write_inheritable_attribute(:not_approved_message, value)
          end
        end
        alias_method :not_approved_message=, :not_approved_message
        
        # The error message used when the record returns false to confirmed?
        #
        # * <tt>Default:</tt> "Your account is not confirmed"
        # * <tt>Accepts:</tt> String
        def not_confirmed_message(value = nil)
          if value.nil?
            read_inheritable_attribute(:not_confirmed_message) || not_confirmed_message("Your account is not confirmed")
          else
            write_inheritable_attribute(:not_confirmed_message, value)
          end
        end
        alias_method :not_confirmed_message=, :not_confirmed_message
        
        # Works exactly like cookie_key, but for params. So a user can login via params just like a cookie or a session. Your URL would look like:
        #
        #   http://www.domain.com?user_credentials=my_single_access_key
        #
        # You can change the "user_credentials" key above with this configuration option. Keep in mind, just like cookie_key, if you supply an id
        # the id will be appended to the front. Check out cookie_key for more details. Also checkout the "Single Access / Private Feeds Access" section in the README.
        #
        # * <tt>Default:</tt> cookie_key
        # * <tt>Accepts:</tt> String
        def params_key(value = nil)
          if value.nil?
            read_inheritable_attribute(:params_key) || params_key(cookie_key)
          else
            write_inheritable_attribute(:params_key, value)
          end
        end
        alias_method :params_key=, :params_key
        
        # The error message used when the password is left blank.
        #
        # * <tt>Default:</tt> "can not be blank"
        # * <tt>Accepts:</tt> String
        def password_blank_message(value = nil)
          if value.nil?
            read_inheritable_attribute(:password_blank_message) || password_blank_message("can not be blank")
          else
            write_inheritable_attribute(:password_blank_message, value)
          end
        end
        alias_method :password_blank_message=, :password_blank_message
        
        # Works exactly like login_field, but for the password instead.
        #
        # * <tt>Default:</tt> :password
        # * <tt>Accepts:</tt> Symbol or String
        def password_field(value = nil)
          if value.nil?
            read_inheritable_attribute(:password_field) || password_field(:password)
          else
            write_inheritable_attribute(:password_field, value)
          end
        end
        alias_method :password_field=, :password_field
        
        # The error message used when the password is invalid.
        #
        # * <tt>Default:</tt> "is invalid"
        # * <tt>Accepts:</tt> String
        def password_invalid_message(value = nil)
          if value.nil?
            read_inheritable_attribute(:password_invalid_message) || password_invalid_message("is invalid")
          else
            write_inheritable_attribute(:password_invalid_message, value)
          end
        end
        alias_method :password_invalid_message=, :password_invalid_message
        
        # If sessions should be remembered by default or not.
        #
        # * <tt>Default:</tt> false
        # * <tt>Accepts:</tt> Boolean
        def remember_me(value = nil)
          if value.nil?
            read_inheritable_attribute(:remember_me)
          else
            write_inheritable_attribute(:remember_me, value)
          end
        end
        alias_method :remember_me=, :remember_me
        
        # The length of time until the cookie expires.
        #
        # * <tt>Default:</tt> 3.months
        # * <tt>Accepts:</tt> Integer, length of time in seconds, such as 60 or 3.months
        def remember_me_for(value = :_read)
          if value == :_read
            read_inheritable_attribute(:remember_me_for) || remember_me_for(3.months)
          else
            write_inheritable_attribute(:remember_me_for, value)
          end
        end
        alias_method :remember_me_for=, :remember_me_for
        
        # Works exactly like cookie_key, but for sessions. See cookie_key for more info.
        #
        # * <tt>Default:</tt> cookie_key
        # * <tt>Accepts:</tt> Symbol or String
        def session_key(value = nil)
          if value.nil?
            read_inheritable_attribute(:session_key) || session_key(cookie_key)
          else
            write_inheritable_attribute(:session_key, value)
          end
        end
        alias_method :session_key=, :session_key
        
        # Authentication is allowed via a single access token, but maybe this is something you don't want for your application as a whole. Maybe this is something you only want for specific request types.
        # Specify a list of allowed request types and single access authentication will only be allowed for the ones you specify. Checkout the "Single Access / Private Feeds Access" section in the README.
        #
        # * <tt>Default:</tt> "application/rss+xml", "application/atom+xml"
        # * <tt>Accepts:</tt> String of request type, or :all to allow single access authentication for any and all request types
        def single_access_allowed_request_types(*values)
          if values.blank?
            read_inheritable_attribute(:single_access_allowed_request_types) || single_access_allowed_request_types("application/rss+xml", "application/atom+xml")
          else
            write_inheritable_attribute(:single_access_allowed_request_types, values)
          end
        end
        alias_method :single_access_allowed_request_types=, :single_access_allowed_request_types
        
        # The name of the method in your model used to verify the password. This should be an instance method. It should also be prepared to accept a raw password and a crytped password.
        #
        # * <tt>Default:</tt> "valid_#{password_field}?"
        # * <tt>Accepts:</tt> Symbol or String
        def verify_password_method(value = nil)
          if value.nil?
            read_inheritable_attribute(:verify_password_method) || verify_password_method("valid_#{password_field}?")
          else
            write_inheritable_attribute(:verify_password_method, value)
          end
        end
        alias_method :verify_password_method=, :verify_password_method
      end
      
      module InstanceMethods # :nodoc:
        def change_single_access_token_with_password?
          self.class.change_single_access_token_with_password == true
        end
        
        def cookie_key
          build_key(self.class.cookie_key)
        end
        
        def disable_magic_states?
          self.class.disable_magic_states == true
        end
        
        def find_by_login_method
          self.class.find_by_login_method
        end
        
        def find_with
          self.class.find_with
        end
        
        def last_request_at_threshold
          self.class.last_request_at_threshold
        end
        
        def login_blank_message
          self.class.login_blank_message
        end
        
        def login_not_found_message
          self.class.login_not_found_message
        end
      
        def login_field
          self.class.login_field
        end
        
        def not_active_message
          self.class.not_active_message
        end
        
        def not_approved_message
          self.class.not_approved_message
        end
        
        def not_confirmed_message
          self.class.not_confirmed_message
        end
        
        def params_allowed_request_types
          build_key(self.class.params_allowed_request_types)
        end
        
        def params_key
          build_key(self.class.params_key)
        end
        
        def password_blank_message
          self.class.password_blank_message
        end
      
        def password_field
          self.class.password_field
        end
        
        def password_invalid_message
          self.class.password_invalid_message
        end
        
        def perishable_token_field
          klass.acts_as_authentic_config[:perishable_token_field]
        end
        
        def remember_me_for
          return unless remember_me?
          self.class.remember_me_for
        end
        
        def persistence_token_field
          klass.acts_as_authentic_config[:persistence_token_field]
        end
        
        def session_key
          build_key(self.class.session_key)
        end
        
        def single_access_token_field
          klass.acts_as_authentic_config[:single_access_token_field]
        end
        
        def single_access_allowed_request_types
          self.class.single_access_allowed_request_types
        end
      
        def verify_password_method
          self.class.verify_password_method
        end
        
        private
          def build_key(last_part)
            key_parts = [id, scope[:id], last_part].compact
            key_parts.join("_")
          end
      end
    end
  end
end