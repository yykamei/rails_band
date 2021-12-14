# frozen_string_literal: true

require 'rails_band/action_cable/event/perform_action'
require 'rails_band/action_cable/event/transmit'

module RailsBand
  module ActionCable
    # The custom LogSubscriber for ActionCable.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def perform_action(event)
        consumer_of(__method__)&.call(Event::PerformAction.new(event))
      end

      def transmit(event)
        consumer_of(__method__)&.call(Event::Transmit.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.action_cable"] || consumers[:action_cable] || consumers[:default]
      end
    end
  end
end
