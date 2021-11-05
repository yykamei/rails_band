# frozen_string_literal: true

module RailsBand
  module ActiveSupport
    module Event
      # A wrapper for the event that is passed to `cache_read.active_support`.
      class CacheRead < BaseEvent
        def key
          @key ||= @event.payload.fetch(:key)
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
          define_method(:store) do
            @store ||= @event.payload.fetch(:store)
          end
        end

        def hit
          return @hit if defined? @hit

          @hit = @event.payload[:hit]
        end

        def super_operation
          return @super_operation if defined? @super_operation

          @super_operation = @event.payload[:super_operation]
        end
      end
    end
  end
end
