# frozen_string_literal: true

module RailsBand
  module ActiveSupport
    module Event
      # A wrapper for the event that is passed to `message_serializer_fallback.active_support`.
      class MessageSerializerFallback < BaseEvent
        def serializer
          @serializer ||= @event.payload.fetch(:serializer)
        end

        def fallback
          @fallback ||= @event.payload.fetch(:fallback)
        end

        def serialized
          @serialized ||= @event.payload.fetch(:serialized)
        end

        def deserialized
          @deserialized ||= @event.payload.fetch(:deserialized)
        end
      end
    end
  end
end
