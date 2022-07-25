# frozen_string_literal: true

require 'rails_band/action_dispatch/event/process_middleware'

module RailsBand
  module ActionDispatch
    # The custom LogSubscriber for ActionDispatch.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def process_middleware(event)
        consumer_of(__method__)&.call(Event::ProcessMiddleware.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.action_dispatch"] || consumers[:action_dispatch] || consumers[:default]
      end
    end
  end
end
