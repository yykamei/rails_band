# frozen_string_literal: true

require 'rails_band/active_support/event/cache_read'
require 'rails_band/active_support/event/cache_generate'
require 'rails_band/active_support/event/cache_fetch_hit'
require 'rails_band/active_support/event/cache_write'
require 'rails_band/active_support/event/cache_delete'
require 'rails_band/active_support/event/cache_exist'

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

      def cache_write(event)
        consumer_of(__method__)&.call(Event::CacheWrite.new(event))
      end

      def cache_delete(event)
        consumer_of(__method__)&.call(Event::CacheDelete.new(event))
      end

      def cache_exist?(event)
        consumer_of(__method__)&.call(Event::CacheExist.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_support"] || consumers[:active_support] || consumers[:default]
      end
    end
  end
end
