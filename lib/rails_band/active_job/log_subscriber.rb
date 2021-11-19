# frozen_string_literal: true

require 'rails_band/active_job/event/enqueue_at'
require 'rails_band/active_job/event/enqueue'
require 'rails_band/active_job/event/enqueue_retry'
require 'rails_band/active_job/event/perform_start'

module RailsBand
  module ActiveJob
    # The custom LogSubscriber for ActiveJob.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def enqueue_at(event)
        consumer_of(__method__)&.call(Event::EnqueueAt.new(event))
      end

      def enqueue(event)
        consumer_of(__method__)&.call(Event::Enqueue.new(event))
      end

      def enqueue_retry(event)
        consumer_of(__method__)&.call(Event::EnqueueRetry.new(event))
      end

      def perform_start(event)
        consumer_of(__method__)&.call(Event::PerformStart.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_job"] || consumers[:active_job] || consumers[:default]
      end
    end
  end
end
