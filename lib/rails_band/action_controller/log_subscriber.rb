# frozen_string_literal: true

require 'rails_band/action_controller/event/write_fragment'
require 'rails_band/action_controller/event/read_fragment'
require 'rails_band/action_controller/event/process_action'

module RailsBand
  module ActionController
    # The custom LogSubscriber for ActionController.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def write_fragment(event)
        consumer_of(__method__)&.call(Event::WriteFragment.new(event))
      end

      def read_fragment(event)
        consumer_of(__method__)&.call(Event::ReadFragment.new(event))
      end

      def expire_fragment(event)
        event
      end

      def exist_fragment?(event)
        event
      end

      def write_page(event)
        event
      end

      def expire_page(event)
        event
      end

      def start_processing(event)
        event
      end

      def process_action(event)
        consumer_of(__method__)&.call(Event::ProcessAction.new(event))
      end

      def send_file(event)
        event
      end

      def send_data(event)
        event
      end

      def redirect_to(event)
        event
      end

      def halted_callback(event)
        event
      end

      def unpermitted_parameters(event)
        event
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.action_controller"] || consumers[:action_controller] || consumers[:default]
      end
    end
  end
end
