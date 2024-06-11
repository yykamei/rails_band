# frozen_string_literal: true

module RailsBand
  module ActiveSupport
    module Event
      # A wrapper for the event that is passed to `cache_cleanup.active_support`.
      class CacheCleanup < BaseEvent
        def store
          @store ||= @event.payload.fetch(:store)
        end

        def size
          @size ||= @event.payload.fetch(:size)
        end
      end
    end
  end
end
