# frozen_string_literal: true

module RailsBand
  module ActiveJob
    module Event
      # A wrapper for the event that is passed to `enqueue.active_job`.
      class EnqueueAll < BaseEvent
        def adapter
          @adapter ||= @event.payload.fetch(:adapter)
        end

        def jobs
          @jobs ||= @event.payload.fetch(:jobs)
        end
      end
    end
  end
end
