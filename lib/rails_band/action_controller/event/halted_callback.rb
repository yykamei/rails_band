# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::HaltedCallback is a wrapper for the event that is passed to `halted_callback.action_controller`.
      class HaltedCallback < BaseEvent
        def filter
          @filter ||= @event.payload.fetch(:filter)
        end
      end
    end
  end
end
