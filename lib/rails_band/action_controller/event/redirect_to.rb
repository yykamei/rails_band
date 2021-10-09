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

        if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
          define_method(:request) do
            @request ||= @event.payload[:request]
          end
        end
      end
    end
  end
end
