# frozen_string_literal: true

module RailsBand
  module ActiveSupport
    module Event
      # A wrapper for the event that is passed to `cache_prune.active_support`.
      class CachePrune < BaseEvent
        def store
          @store ||= @event.payload.fetch(:store)
        end

        def key
          @key ||= @event.payload.fetch(:key)
        end

        def from
          @from ||= @event.payload.fetch(:from)
        end
      end
    end
  end
end
