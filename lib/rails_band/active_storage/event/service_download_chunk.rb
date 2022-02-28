# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `service_download_chunk.active_storage`.
      class ServiceDownloadChunk < BaseEvent
        def key
          return @key if defined? @key

          @key = @event.payload[:key]
        end

        def service
          @service ||= @event.payload.fetch(:service)
        end

        def range
          @range ||= @event.payload.fetch(:range)
        end
      end
    end
  end
end
