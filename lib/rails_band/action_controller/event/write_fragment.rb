# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::WriteFragment is a wrapper for the event that is passed to `write_fragment.action_controller`.
      class WriteFragment < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end
      end
    end
  end
end
