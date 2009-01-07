RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

AUTHORIZATION_MIXIN = 'hardwired'
LOGIN_REQUIRED_REDIRECTION = { :controller => '/user_sessions', :action => :new }
PERMISSION_DENIED_REDIRECTION = { :controller => '/recipes', :action => :index }
STORE_LOCATION_METHOD = :store_location

Rails::Initializer.run do |config|
  config.gem 'ruby-units'
  config.gem 'rubaidh-google_analytics', :lib => 'rubaidh/google_analytics', :source => 'http://gems.github.com'
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_baker_session',
    :secret      => 'f9f0287e5a95154c0a2672750ca3fb2cfd1eb89e9ff409c4a1ed9c247b267051f794f6db413d45dd844bff702b3086c61fce4d4d1450ae14d95cc210dee515e6'
  }
end

require 'almost'
Rubaidh::GoogleAnalytics.tracker_id = 'UA-6821662-2'
