# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # A wrapper for the event that is passed to `redirect_to.action_controller`.
      class RedirectTo < BaseEvent
        def status
          @status ||= @event.payload.fetch(:status)
        end

        def location
          @location ||= @event.payload.fetch(:location)
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
