# frozen_string_literal: true

require 'rails_band/action_view/from_views'

module RailsBand
  module ActionView
    module Event
      # A wrapper for the event that is passed to `render_template.action_view`.
      class RenderTemplate < BaseEvent
        include FromViews

        def identifier
          @identifier ||= from_views(@event.payload.fetch(:identifier))
        end

        def layout
          return @layout if defined? @layout

          @layout = @event.payload[:layout]&.then { |layout| from_views(layout) }
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
          define_method(:locals) do
            @locals ||= @event.payload[:locals]
          end
        end
      end
    end
  end
end
