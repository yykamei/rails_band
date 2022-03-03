# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `preview.active_storage`.
      class Preview < BaseEvent
        def key
          return @key if defined? @key

          @key = @event.payload[:key]
        end
      end
    end
  end
end
