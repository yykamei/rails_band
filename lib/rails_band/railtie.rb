# frozen_string_literal: true

require 'action_controller/log_subscriber'
require 'action_view/log_subscriber'

module RailsBand
  # RailsBand::Railtie is responsible for preparing its configuration and accepting user-specified configs.
  class Railtie < ::Rails::Railtie
    config.rails_band = Configuration.new

    config.before_initialize do
      # NOTE: `ActionDispatch::MiddlewareStack::InstrumentationProxy` will be called
      #       only when `ActionDispatch::MiddlewareStack#build` detects `process_middleware.action_dispatch`
      #       is listened to. So, `attach_to` must be called before Rack middlewares will be loaded.
      if defined?(::ActionDispatch::LogSubscriber)
        detach_log_subscriber(::ActionDispatch::LogSubscriber, :action_dispatch)
      end
      RailsBand::ActionDispatch::LogSubscriber.attach_to :action_dispatch
    end

    config.after_initialize do |app|
      consumers = app.config.rails_band.consumers

      swap = lambda { |old_class, new_class, namespace|
        detach_log_subscriber(old_class, namespace)
        new_class.consumers = consumers
        new_class.attach_to namespace
      }

      swap.call(::ActionController::LogSubscriber, RailsBand::ActionController::LogSubscriber, :action_controller)
      swap.call(::ActionView::LogSubscriber, RailsBand::ActionView::LogSubscriber, :action_view)

      if defined?(::ActiveRecord)
        require 'active_record/log_subscriber'
        swap.call(::ActiveRecord::LogSubscriber, RailsBand::ActiveRecord::LogSubscriber, :active_record)
      end

      if defined?(::ActionMailer)
        require 'action_mailer/log_subscriber'
        swap.call(::ActionMailer::LogSubscriber, RailsBand::ActionMailer::LogSubscriber, :action_mailer)
      end

      if defined?(::ActionCable)
        RailsBand::ActionCable::LogSubscriber.consumers = consumers
        RailsBand::ActionCable::LogSubscriber.attach_to :action_cable
      end

      if defined?(::ActiveStorage)
        RailsBand::ActiveStorage::LogSubscriber.consumers = consumers
        RailsBand::ActiveStorage::LogSubscriber.attach_to :active_storage
      end

      RailsBand::ActionDispatch::LogSubscriber.consumers = consumers

      RailsBand::ActiveSupport::LogSubscriber.consumers = consumers
      RailsBand::ActiveSupport::LogSubscriber.attach_to :active_support

      RailsBand::DeprecationSubscriber.consumers = consumers
      RailsBand::DeprecationSubscriber.attach_to :rails

      if defined?(::ActiveJob)
        require 'active_job/logging'

        if defined?(::ActiveJob::Logging::LogSubscriber)
          swap.call(::ActiveJob::Logging::LogSubscriber, RailsBand::ActiveJob::LogSubscriber, :active_job)
        else
          require 'active_job/log_subscriber'
          swap.call(::ActiveJob::LogSubscriber, RailsBand::ActiveJob::LogSubscriber, :active_job)
        end
      end

      if defined?(::ActionMailbox)
        RailsBand::ActionMailbox::LogSubscriber.consumers = consumers
        RailsBand::ActionMailbox::LogSubscriber.attach_to :action_mailbox
      end
    end

    # Helper method to detach log subscribers in a way that's compatible with both
    # Rails < 8.1 (using detach_from) and Rails >= 8.1 (using unsubscribe)
    def self.detach_log_subscriber(log_subscriber_class, namespace)
      if log_subscriber_class.respond_to?(:detach_from)
        # Rails < 8.1: use detach_from method
        log_subscriber_class.detach_from namespace
      elsif log_subscriber_class.respond_to?(:unsubscribe)
        # Rails >= 8.1: use unsubscribe method
        log_subscriber_class.unsubscribe
      end
    end

    private_class_method :detach_log_subscriber
  end
end
