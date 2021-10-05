# frozen_string_literal: true

require 'rails_band/active_record/event/sql'

module RailsBand
  module ActiveRecord
    # The custom LogSubscriber for ActiveRecord.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def sql(event)
        consumer_of(__method__)&.call(Event::Sql.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_record"] || consumers[:active_record] || consumers[:default]
      end
    end
  end
end
