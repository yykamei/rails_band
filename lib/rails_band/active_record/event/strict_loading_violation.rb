# frozen_string_literal: true

module RailsBand
  module ActiveRecord
    module Event
      # A wrapper for the event that is passed to `strict_loading_violation.active_record`.
      class StrictLoadingViolation < BaseEvent
        def owner
          @owner ||= @event.payload.fetch(:owner)
        end

        def reflection
          @reflection ||= @event.payload.fetch(:reflection)
        end
      end
    end
  end
end
