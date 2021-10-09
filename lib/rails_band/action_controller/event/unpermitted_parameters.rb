# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # A wrapper for the event that is passed to `unpermitted_parameters.action_controller`.
      class UnpermittedParameters < BaseEvent
        def keys
          @keys ||= @event.payload.fetch(:keys)
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
          # @see https://github.com/rails/rails/pull/41809
          define_method(:controller) do
            @controller ||= @event.payload.dig(:context, :controller)
          end
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
          # @see https://github.com/rails/rails/pull/41809
          define_method(:action) do
            @action ||= @event.payload.dig(:context, :action)
          end
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
          # @see https://github.com/rails/rails/pull/41809
          define_method(:request) do
            @request ||= @event.payload.dig(:context, :request)
          end
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
          # @see https://github.com/rails/rails/pull/41809
          define_method(:params) do
            @params ||= @event.payload.dig(:context, :params)
          end
        end
      end
    end
  end
end
