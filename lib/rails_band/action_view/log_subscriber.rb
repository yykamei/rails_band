# frozen_string_literal: true

require 'rails_band/action_view/event/render_template'
require 'rails_band/action_view/event/render_partial'

module RailsBand
  module ActionView
    # The custom LogSubscriber for ActionView.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def render_template(event)
        consumer_of(__method__)&.call(Event::RenderTemplate.new(event))
      end

      def render_partial(event)
        consumer_of(__method__)&.call(Event::RenderPartial.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.action_view"] || consumers[:action_view] || consumers[:default]
      end
    end
  end
end
