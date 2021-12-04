# frozen_string_literal: true

module RailsBand
  module ActionCable
    module Event
      # A wrapper for the event that is passed to `perform_action.action_cable`.
      class PerformAction < BaseEvent
        def channel_class
          @channel_class ||= @event.payload.fetch(:channel_class)
        end

        def action
          @action ||= @event.payload.fetch(:action)
        end

        def data
          @data ||= @event.payload.fetch(:data)
        end
      end
    end
  end
end
