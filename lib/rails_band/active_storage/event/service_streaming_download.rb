# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `service_streaming_download.active_storage`.
      class ServiceStreamingDownload < BaseEvent
        def key
          return @key if defined? @key

          @key = @event.payload[:key]
        end

        def service
          @service ||= @event.payload.fetch(:service)
        end
      end
    end
  end
end
