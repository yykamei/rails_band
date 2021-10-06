# frozen_string_literal: true

require 'rails_band/action_view/from_views'

module RailsBand
  module ActionView
    module Event
      # A wrapper for the event that is passed to `render_collection.action_view`.
      class RenderCollection < BaseEvent
        include FromViews

        def identifier
          @identifier ||= from_views(@event.payload.fetch(:identifier))
        end

        def layout
          return @layout if defined? @layout

          @layout = @event.payload[:layout]&.yield_self { |layout| from_views(layout) }
        end

        def count
          @count ||= @event.payload.fetch(:count)
        end

        def cache_hits
          return @cache_hits if defined? @cache_hits

          @cache_hits = @event.payload[:cache_hits]
        end
      end
    end
  end
end
