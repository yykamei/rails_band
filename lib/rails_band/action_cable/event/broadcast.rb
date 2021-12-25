# frozen_string_literal: true

module RailsBand
  module ActionCable
    module Event
      # A wrapper for the event that is passed to `broadcast.action_cable`.
      class Broadcast < BaseEvent
        def broadcasting
          @broadcasting ||= @event.payload.fetch(:broadcasting)
        end

        def message
          @message ||= @event.payload.fetch(:message)
        end

        def coder
          @coder ||= @event.payload.fetch(:coder)
        end
      end
    end
  end
end
