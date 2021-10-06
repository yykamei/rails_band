# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # A wrapper for the event that is passed to `start_processing.action_controller`.
      class StartProcessing < BaseEvent
        def controller
          @controller ||= @event.payload.fetch(:controller)
        end

        def action
          @action ||= @event.payload.fetch(:action)
        end

        def params
          @params ||= @event.payload.fetch(:params).except(*INTERNAL_PARAMS)
        end

        def headers
          @headers ||= @event.payload.fetch(:headers)
        end

        def format
          @format ||= @event.payload.fetch(:format)
        end

        def method
          @method ||= @event.payload.fetch(:method)
        end

        def path
          @path ||= @event.payload.fetch(:path).split('?', 2).first
        end

        # @todo: Raise NoMethodError if the lower version of Rails could be used in the future.
        def request
          return @request if defined? @request

          @request = @event.payload[:request]
        end
      end
    end
  end
end
