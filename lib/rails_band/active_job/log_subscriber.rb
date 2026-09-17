# frozen_string_literal: true

require 'rails_band/active_job/event/enqueue_at'
require 'rails_band/active_job/event/enqueue_all'
require 'rails_band/active_job/event/enqueue'
require 'rails_band/active_job/event/enqueue_retry'
require 'rails_band/active_job/event/perform_start'
require 'rails_band/active_job/event/perform'
require 'rails_band/active_job/event/retry_stopped'
require 'rails_band/active_job/event/discard'
require 'rails_band/active_job/event/interrupt'
require 'rails_band/active_job/event/resume'
require 'rails_band/active_job/event/step'
require 'rails_band/active_job/event/step_skipped'
require 'rails_band/active_job/event/step_started'

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

      def perform(event)
        consumer_of(__method__)&.call(Event::Perform.new(event))
      end

      def retry_stopped(event)
        consumer_of(__method__)&.call(Event::RetryStopped.new(event))
      end

      def discard(event)
        consumer_of(__method__)&.call(Event::Discard.new(event))
      end

      def enqueue_all(event)
        consumer_of(__method__)&.call(Event::EnqueueAll.new(event))
      end

      def interrupt(event)
        consumer_of(__method__)&.call(Event::Interrupt.new(event))
      end

      def resume(event)
        consumer_of(__method__)&.call(Event::Resume.new(event))
      end

      def step(event)
        consumer_of(__method__)&.call(Event::Step.new(event))
      end

      def step_skipped(event)
        consumer_of(__method__)&.call(Event::StepSkipped.new(event))
      end

      def step_started(event)
        consumer_of(__method__)&.call(Event::StepStarted.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_job"] || consumers[:active_job] || consumers[:default]
      end
    end
  end
end
