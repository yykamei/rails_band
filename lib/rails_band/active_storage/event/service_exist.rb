# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `service_exist.active_storage`.
      class ServiceExist < BaseEvent
        def key
          return @key if defined? @key

          @key = @event.payload[:key]
        end

        def service
          @service ||= @event.payload.fetch(:service)
        end

        def exist
          return @exist if defined? @exist

          @exist = @event.payload.fetch(:exist)
        end
      end
    end
  end
end
