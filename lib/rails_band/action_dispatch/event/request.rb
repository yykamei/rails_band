# frozen_string_literal: true

module RailsBand
  module ActionDispatch
    module Event
      # A wrapper for the event that is passed to `redirect.action_dispatch`.
      class Request < BaseEvent
        def request
          @request ||= @event.payload.fetch(:request)
        end
      end
    end
  end
end
