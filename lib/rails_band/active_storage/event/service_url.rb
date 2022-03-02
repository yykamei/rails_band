# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `service_url.active_storage`.
      class ServiceUrl < BaseEvent
        def key
          return @key if defined? @key

          @key = @event.payload[:key]
        end

        def service
          @service ||= @event.payload.fetch(:service)
        end

        def url
          @url ||= @event.payload.fetch(:url)
        end
      end
    end
  end
end
