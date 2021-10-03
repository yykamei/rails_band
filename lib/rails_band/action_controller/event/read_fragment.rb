# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::ReadFragment is a wrapper for the event that is passed to `read_fragment.action_controller`.
      class ReadFragment < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end
      end
    end
  end
end
