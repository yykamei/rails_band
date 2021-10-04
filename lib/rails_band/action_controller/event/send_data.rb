# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::SendData is a wrapper for the event that is passed to `send_data.action_controller`.
      class SendData < BaseEvent
        def filename
          return @filename if defined? @filename

          @filename = @event.payload[:filename]
        end

        def type
          return @type if defined? @type

          @type = @event.payload[:type]
        end

        def disposition
          return @disposition if defined? @disposition

          @disposition = @event.payload[:disposition]
        end

        def status
          return @status if defined? @status

          @status = @event.payload[:status]
        end
      end
    end
  end
end
