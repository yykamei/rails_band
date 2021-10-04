# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::UnpermittedParameters is a wrapper for the event that is passed
      # to `unpermitted_parameters.action_controller`.
      class UnpermittedParameters < BaseEvent
        def keys
          @keys ||= @event.payload.fetch(:keys)
        end

        # @see https://github.com/rails/rails/pull/41809
        # @todo: Raise NoMethodError if the lower version of Rails could be used in the future.
        def controller
          return @controller if defined? @controller

          @controller = @event.payload.dig(:context, :controller)
        end

        # @see https://github.com/rails/rails/pull/41809
        # @todo: Raise NoMethodError if the lower version of Rails could be used in the future.
        def action
          return @action if defined? @action

          @action = @event.payload.dig(:context, :action)
        end

        # @see https://github.com/rails/rails/pull/41809
        # @todo: Raise NoMethodError if the lower version of Rails could be used in the future.
        def request
          return @request if defined? @request

          @request = @event.payload.dig(:context, :request)
        end

        # @see https://github.com/rails/rails/pull/41809
        # @todo: Raise NoMethodError if the lower version of Rails could be used in the future.
        def params
          return @params if defined? @params

          @params = @event.payload.dig(:context, :params)
        end
      end
    end
  end
end
