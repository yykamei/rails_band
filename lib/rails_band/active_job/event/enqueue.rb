# frozen_string_literal: true

module RailsBand
  module ActiveJob
    module Event
      # A wrapper for the event that is passed to `enqueue.active_job`.
      class Enqueue < BaseEvent
        def adapter
          @adapter ||= @event.payload.fetch(:adapter)
        end

        def job
          @job ||= @event.payload.fetch(:job)
        end

        if Gem::Version.new(Rails.version) > Gem::Version.new('7.0')
          define_method(:aborted) do
            return @aborted if defined?(@aborted)

            @aborted = @event.payload[:aborted]
          end
        end
      end
    end
  end
end
