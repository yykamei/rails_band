# frozen_string_literal: true

require 'rails_band/version'
require 'rails_band/configuration'
require 'rails_band/base_event'
require 'rails_band/railtie'

# Rails::Band unsubscribes all default LogSubscribers from Rails Instrumentation API,
# and it subscribes our own custom LogSubscribers to make it easy to access Rails Instrumentation API.
module RailsBand
  module ActionController
    autoload :LogSubscriber, 'rails_band/action_controller/log_subscriber'
  end
end
