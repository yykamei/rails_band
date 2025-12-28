# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # A wrapper for the event that is passed to `rate_limit.action_controller`.
      class RateLimit < BaseEvent
        def request
          @request ||= @event.payload.fetch(:request)
        end

        # @note The following attributes are only available in Rails 8.1+
        if Gem::Version.new(Rails.version) >= Gem::Version.new('8.1.0.alpha')
          define_method(:count) do
            @count ||= @event.payload.fetch(:count)
          end

          define_method(:to) do
            @to ||= @event.payload.fetch(:to)
          end

          define_method(:within) do
            @within ||= @event.payload.fetch(:within)
          end

          define_method(:by) do
            @by ||= @event.payload.fetch(:by)
          end

          # @note This method is renamed in order to avoid conflicts with BaseEvent#name.
          define_method(:rate_limit_name) do
            return @rate_limit_name if defined? @rate_limit_name

            @rate_limit_name = @event.payload[:name]
          end

          define_method(:scope) do
            @scope ||= @event.payload.fetch(:scope)
          end

          define_method(:cache_key) do
            @cache_key ||= @event.payload.fetch(:cache_key)
          end
        end
      end
    end
  end
end
