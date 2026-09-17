# frozen_string_literal: true

module RailsBand
  module ActiveRecord
    module Event
      # A wrapper for the event that is passed to `deprecated_association.active_record`.
      class DeprecatedAssociation < BaseEvent
        def reflection
          @reflection ||= @event.payload.fetch(:reflection)
        end

        def message
          @message ||= @event.payload.fetch(:message)
        end

        def location
          @location ||= @event.payload.fetch(:location)
        end

        # `:backtrace` is only present when the option is enabled; `fetch` would
        # raise KeyError in the default configuration.
        def backtrace
          @backtrace ||= @event.payload[:backtrace]
        end
      end
    end
  end
end
