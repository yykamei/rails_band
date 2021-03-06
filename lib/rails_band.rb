# frozen_string_literal: true

require 'rails_band/version'
require 'rails_band/configuration'
require 'rails_band/base_event'
require 'rails_band/deprecation_subscriber'
require 'rails_band/railtie'

# Rails::Band unsubscribes all default LogSubscribers from Rails Instrumentation API,
# and it subscribes our own custom LogSubscribers to make it easy to access Rails Instrumentation API.
module RailsBand
  module ActionController
    autoload :LogSubscriber, 'rails_band/action_controller/log_subscriber'
  end

  module ActionView
    autoload :LogSubscriber, 'rails_band/action_view/log_subscriber'
  end

  module ActiveRecord
    autoload :LogSubscriber, 'rails_band/active_record/log_subscriber'
  end

  module ActionMailer
    autoload :LogSubscriber, 'rails_band/action_mailer/log_subscriber'
  end

  module ActionDispatch
    autoload :LogSubscriber, 'rails_band/action_dispatch/log_subscriber'
  end

  module ActiveSupport
    autoload :LogSubscriber, 'rails_band/active_support/log_subscriber'
  end

  module ActiveJob
    autoload :LogSubscriber, 'rails_band/active_job/log_subscriber'
  end

  module ActionCable
    autoload :LogSubscriber, 'rails_band/action_cable/log_subscriber'
  end

  module ActiveStorage
    autoload :LogSubscriber, 'rails_band/active_storage/log_subscriber'
  end
end
