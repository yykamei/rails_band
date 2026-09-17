# frozen_string_literal: true

require 'rails_band/railties/event/load_config_initializer'

module RailsBand
  module Railties
    # LogSubscriber is responsible for calling the user-specified consumer for railties events.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def load_config_initializer(event)
        consumer&.call(Event::LoadConfigInitializer.new(event))
      end

      private

      def consumer
        # HACK: ActiveSupport::Subscriber has the instance variable @namespace, but it's not documented.
        #       This hack might possibly break in the future.
        namespace = self.class.instance_variable_get(:@namespace)
        consumers[:"load_config_initializer.#{namespace}"] || consumers[:railties] || consumers[:default]
      end
    end
  end
end
