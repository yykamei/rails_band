# frozen_string_literal: true

require 'action_controller/log_subscriber'
require 'action_view/log_subscriber'

module RailsBand
  # RailsBand::Railtie is responsible for preparing its configuration and accepting user-specified configs.
  class Railtie < ::Rails::Railtie
    config.rails_band = Configuration.new

    config.after_initialize do |app|
      consumers = app.config.rails_band.consumers

      swap = lambda { |old_class, new_class, namespace|
        old_class.detach_from namespace
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
        RailsBand::ActionCable::LogSubscriber.attach_to :action_cable
      end

      RailsBand::ActiveSupport::LogSubscriber.attach_to :active_support

      if defined?(::ActiveJob)
        require 'active_job/logging'

        if defined?(::ActiveJob::Logging::LogSubscriber)
          swap.call(::ActiveJob::Logging::LogSubscriber, RailsBand::ActiveJob::LogSubscriber, :active_job)
        else
          require 'active_job/log_subscriber'
          swap.call(::ActiveJob::LogSubscriber, RailsBand::ActiveJob::LogSubscriber, :active_job)
        end
      end
    end
  end
end
