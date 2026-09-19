# frozen_string_literal: true

module RailsBand
  module Railties
    module Event
      # A wrapper for the event that is passed to `load_config_initializer.railties`.
      class LoadConfigInitializer < BaseEvent
        def initializer
          @initializer ||= @event.payload.fetch(:initializer)
        end
      end
    end
  end
end
