# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `service_update_metadata.active_storage`.
      class ServiceUpdateMetadata < BaseEvent
        def key
          return @key if defined? @key

          @key = @event.payload[:key]
        end

        def service
          @service ||= @event.payload.fetch(:service)
        end

        def content_type
          @content_type ||= @event.payload.fetch(:content_type)
        end

        def disposition
          @disposition ||= @event.payload.fetch(:disposition)
        end
      end
    end
  end
end
