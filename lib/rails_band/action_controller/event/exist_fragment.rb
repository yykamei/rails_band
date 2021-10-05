# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::ExistFragment is a wrapper for the event that is passed
      # to `exist_fragment?.action_controller`.
      class ExistFragment < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end
      end
    end
  end
end
