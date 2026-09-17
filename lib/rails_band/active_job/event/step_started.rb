# frozen_string_literal: true

module RailsBand
  module ActiveJob
    module Event
      # A wrapper for the event that is passed to `step_started.active_job`.
      class StepStarted < BaseEvent
        def adapter
          @adapter ||= @event.payload.fetch(:adapter)
        end

        def job
          @job ||= @event.payload.fetch(:job)
        end

        def step
          @step ||= @event.payload.fetch(:step)
        end
      end
    end
  end
end
