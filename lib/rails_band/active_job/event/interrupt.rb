# frozen_string_literal: true

module RailsBand
  module ActiveJob
    module Event
      # A wrapper for the event that is passed to `interrupt.active_job`.
      class Interrupt < BaseEvent
        def adapter
          @adapter ||= @event.payload.fetch(:adapter)
        end

        def job
          @job ||= @event.payload.fetch(:job)
        end

        def reason
          @reason ||= @event.payload.fetch(:reason)
        end

        def description
          @description ||= @event.payload.fetch(:description)
        end

        def completed_steps
          @completed_steps ||= @event.payload.fetch(:completed_steps)
        end

        def current_step
          @current_step ||= @event.payload[:current_step]
        end
      end
    end
  end
end
