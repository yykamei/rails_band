# frozen_string_literal: true

module RailsBand
  module ActionDispatch
    module Event
      # A wrapper for the event that is passed to `redirect.action_dispatch`.
      class Redirect < BaseEvent
        def status
          @status ||= @event.payload.fetch(:status)
        end

        def location
          @location ||= @event.payload.fetch(:location)
        end

        def request
          @request ||= @event.payload.fetch(:request)
        end
      end
    end
  end
end
