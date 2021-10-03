# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::ExpireFragment is a wrapper for the event that is passed to `expire_fragment.action_controller`.
      class ExpireFragment < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end
      end
    end
  end
end
