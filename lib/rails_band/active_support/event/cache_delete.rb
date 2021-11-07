# frozen_string_literal: true

module RailsBand
  module ActiveSupport
    module Event
      # A wrapper for the event that is passed to `cache_delete.active_support`.
      class CacheDelete < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
          define_method(:store) do
            @store ||= @event.payload.fetch(:store)
          end
        end
      end
    end
  end
end
