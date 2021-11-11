# frozen_string_literal: true

require 'rails_band/active_job/event/enqueue_at'

module RailsBand
  module ActiveJob
    # The custom LogSubscriber for ActiveJob.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def enqueue_at(event)
        consumer_of(__method__)&.call(Event::EnqueueAt.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_job"] || consumers[:active_job] || consumers[:default]
      end
    end
  end
end
