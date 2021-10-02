# frozen_string_literal: true

require 'action_controller/log_subscriber'

module RailsBand
  # RailsBand::Railtie is responsible for preparing its configuration and accepting user-specified configs.
  class Railtie < ::Rails::Railtie
    config.rails_band = Configuration.new

    config.after_initialize do |app|
      consumers = app.config.rails_band.consumers

      ::ActionController::LogSubscriber.detach_from :action_controller
      RailsBand::ActionController::LogSubscriber.consumers = consumers
      RailsBand::ActionController::LogSubscriber.attach_to :action_controller
    end
  end
end
