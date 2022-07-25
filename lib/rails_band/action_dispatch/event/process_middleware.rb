# frozen_string_literal: true

module RailsBand
  module ActionDispatch
    module Event
      # A wrapper for the event that is passed to `process_middleware.action_dispatch`.
      class ProcessMiddleware < BaseEvent
        def middleware
          @middleware ||= @event.payload.fetch(:middleware)
        end
      end
    end
  end
end
