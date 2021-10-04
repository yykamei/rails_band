# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # ActionController::SendFile is a wrapper for the event that is passed to `send_file.action_controller`.
      class SendFile < BaseEvent
        def path
          @path ||= @event.payload.fetch(:path)
        end

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

        def url_based_filename
          return @url_based_filename if defined? @url_based_filename

          @url_based_filename = @event.payload[:url_based_filename]
        end
      end
    end
  end
end
