# frozen_string_literal: true

require 'rails_band/active_support/event/cache_read'
require 'rails_band/active_support/event/cache_generate'
require 'rails_band/active_support/event/cache_fetch_hit'

module RailsBand
  module ActiveSupport
    # The custom LogSubscriber for ActiveSupport.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def cache_read(event)
        consumer_of(__method__)&.call(Event::CacheRead.new(event))
      end

      def cache_generate(event)
        consumer_of(__method__)&.call(Event::CacheGenerate.new(event))
      end

      def cache_fetch_hit(event)
        consumer_of(__method__)&.call(Event::CacheFetchHit.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_support"] || consumers[:active_support] || consumers[:default]
      end
    end
  end
end
