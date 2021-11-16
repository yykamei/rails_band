# frozen_string_literal: true

module RailsBand
  module ActiveJob
    module Event
      # A wrapper for the event that is passed to `enqueue_retry.active_job`.
      class EnqueueRetry < BaseEvent
        def adapter
          @adapter ||= @event.payload.fetch(:adapter)
        end

        def job
          @job ||= @event.payload.fetch(:job)
        end

        def wait
          @wait ||= @event.payload.fetch(:wait)
        end

        def error
          @error ||= @event.payload.fetch(:error)
        end
      end
    end
  end
end
