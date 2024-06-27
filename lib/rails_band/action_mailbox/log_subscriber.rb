# frozen_string_literal: true

require 'rails_band/action_mailbox/event/process'

module RailsBand
  module ActionMailbox
    # The custom LogSubscriber for ActionMailbox.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def process(event)
        consumer_of(__method__)&.call(Event::Process.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.action_mailbox"] || consumers[:action_mailbox] || consumers[:default]
      end
    end
  end
end
