# frozen_string_literal: true

module RailsBand
  module ActiveStorage
    module Event
      # A wrapper for the event that is passed to `analyze.active_storage`.
      class Analyze < BaseEvent
        def analyzer
          @analyzer ||= @event.payload.fetch(:analyzer)
        end
      end
    end
  end
end
