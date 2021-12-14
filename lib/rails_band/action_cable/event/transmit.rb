# frozen_string_literal: true

module RailsBand
  module ActionCable
    module Event
      # A wrapper for the event that is passed to `transmit.action_cable`.
      class Transmit < BaseEvent
        def channel_class
          @channel_class ||= @event.payload.fetch(:channel_class)
        end

        def data
          @data ||= @event.payload.fetch(:data)
        end

        def via
          @via ||= @event.payload.fetch(:via)
        end
      end
    end
  end
end
