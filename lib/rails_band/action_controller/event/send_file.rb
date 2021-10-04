# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::SendFile is a wrapper for the event that is passed to `send_file.action_controller`.
      class SendFile < BaseEvent
        def path
          @path ||= @event.payload.fetch(:path)
        end

        def additional_keys
          @additional_keys ||= @event.payload.reject { |key, _value| key == :path }
        end
      end
    end
  end
end
