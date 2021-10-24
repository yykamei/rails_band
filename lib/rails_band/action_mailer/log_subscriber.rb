# frozen_string_literal: true

require 'rails_band/action_mailer/event/deliver'

module RailsBand
  module ActionMailer
    # The custom LogSubscriber for ActionMailer.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def deliver(event)
        consumer_of(__method__)&.call(Event::Deliver.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.action_mailer"] || consumers[:action_mailer] || consumers[:default]
      end
    end
  end
end
