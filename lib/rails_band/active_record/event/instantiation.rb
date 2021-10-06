# frozen_string_literal: true

module RailsBand
  module ActiveRecord
    module Event
      # A wrapper for the event that is passed to `instantiation.active_record`.
      class Instantiation < BaseEvent
        def record_count
          @record_count ||= @event.payload.fetch(:record_count)
        end

        def class_name
          @class_name ||= @event.payload.fetch(:class_name)
        end
      end
    end
  end
end
