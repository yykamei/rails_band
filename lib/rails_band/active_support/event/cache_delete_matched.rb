# frozen_string_literal: true

module RailsBand
  module ActiveSupport
    module Event
      # A wrapper for the event that is passed to `cache_delete_matched.active_support`.
      class CacheDeleteMatched < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end

        def store
          @store ||= @event.payload.fetch(:store)
        end
      end
    end
  end
end
