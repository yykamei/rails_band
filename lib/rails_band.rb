# frozen_string_literal: true

require 'rails_band/version'
require 'rails_band/configuration'
require 'rails_band/base_event'
require 'rails_band/deprecation_subscriber'
require 'rails_band/railtie'

# Rails::Band unsubscribes all default LogSubscribers from Rails Instrumentation API,
# and it subscribes our own custom LogSubscribers to make it easy to access Rails Instrumentation API.
module RailsBand
  # RailsBand::ActionController is responsible for subscribing notifications from ActionController.
  module ActionController
    autoload :LogSubscriber, 'rails_band/action_controller/log_subscriber'
  end

  # RailsBand::ActionView is responsible for subscribing notifications from ActionView.
  module ActionView
    autoload :LogSubscriber, 'rails_band/action_view/log_subscriber'
  end

  # RailsBand::ActiveRecord is responsible for subscribing notifications from ActiveRecord.
  module ActiveRecord
    autoload :LogSubscriber, 'rails_band/active_record/log_subscriber'
  end

  # RailsBand::ActionMailer is responsible for subscribing notifications from ActionMailer.
  module ActionMailer
    autoload :LogSubscriber, 'rails_band/action_mailer/log_subscriber'
  end

  # RailsBand::ActionDispatch is responsible for subscribing notifications from ActionDispatch.
  module ActionDispatch
    autoload :LogSubscriber, 'rails_band/action_dispatch/log_subscriber'
  end

  # RailsBand::ActiveSupport is responsible for subscribing notifications from ActiveSupport.
  module ActiveSupport
    autoload :LogSubscriber, 'rails_band/active_support/log_subscriber'
  end

  # RailsBand::ActiveJob is responsible for subscribing notifications from ActiveJob.
  module ActiveJob
    autoload :LogSubscriber, 'rails_band/active_job/log_subscriber'
  end

  # RailsBand::ActionCable is responsible for subscribing notifications from ActionCable.
  module ActionCable
    autoload :LogSubscriber, 'rails_band/action_cable/log_subscriber'
  end

  # RailsBand::ActiveStorage is responsible for subscribing notifications from ActiveStorage.
  module ActiveStorage
    autoload :LogSubscriber, 'rails_band/active_storage/log_subscriber'
  end
end
