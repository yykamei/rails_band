# frozen_string_literal: true

require 'rails_band/action_view/from_views'

module RailsBand
  module ActionView
    module Event
      # ActionView::RenderPartial is a wrapper for the event that is passed to `render_partial.action_view`.
      class RenderPartial < BaseEvent
        include FromViews

        def identifier
          @identifier ||= from_views(@event.payload.fetch(:identifier))
        end

        def layout
          return @layout if defined? @layout

          @layout = @event.payload[:layout]&.yield_self { |layout| from_views(layout) }
        end

        def cache_hit
          @cache_hit ||= @event.payload.fetch(:cache_hit)
        end
      end
    end
  end
end
