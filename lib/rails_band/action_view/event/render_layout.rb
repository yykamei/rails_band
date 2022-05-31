# frozen_string_literal: true

require 'rails_band/action_view/from_views'

module RailsBand
  module ActionView
    module Event
      # A wrapper for the event that is passed to `render_layout.action_view`.
      class RenderLayout < BaseEvent
        include FromViews

        def identifier
          @identifier ||= from_views(@event.payload.fetch(:identifier))
        end
      end
    end
  end
end
