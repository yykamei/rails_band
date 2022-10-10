# frozen_string_literal: true

module RailsBand
  module ActiveJob
    module Event
      # A wrapper for the event that is passed to `perform.active_job`.
      class Perform < BaseEvent
        def adapter
          @adapter ||= @event.payload.fetch(:adapter)
        end

        def job
          @job ||= @event.payload.fetch(:job)
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
          define_method(:aborted) do
            return @aborted if defined?(@aborted)

            @aborted = @event.payload[:aborted]
          end

          define_method(:db_runtime) do
            @db_runtime ||= @event.payload[:db_runtime]
          end
        end
      end
    end
  end
end
