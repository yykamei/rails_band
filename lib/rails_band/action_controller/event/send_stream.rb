# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # A wrapper for the event that is passed to `send_stream.action_controller`.
      class SendStream < BaseEvent

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
      end
    end
  end
end
