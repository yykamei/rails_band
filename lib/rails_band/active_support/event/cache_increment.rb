# frozen_string_literal: true

module RailsBand
  module ActiveSupport
    module Event
      # A wrapper for the event that is passed to `cache_increment.active_support`.
      class CacheIncrement < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end

        def store
          @store ||= @event.payload.fetch(:store)
        end

        def amount
          @amount ||= @event.payload.fetch(:amount)
        end
      end
    end
  end
end
