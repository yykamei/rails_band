# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `service_delete_prefixed.active_storage`.
      class ServiceDeletePrefixed < BaseEvent
        def prefix
          @prefix ||= @event.payload.fetch(:prefix)
        end

        def service
          @service ||= @event.payload.fetch(:service)
        end
      end
    end
  end
end
