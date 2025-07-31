# frozen_string_literal: true

require 'rails_band/active_record/event/sql'
require 'rails_band/active_record/event/instantiation'
require 'rails_band/active_record/event/strict_loading_violation'
require 'rails_band/active_record/event/start_transaction'

module RailsBand
  module ActiveRecord
    # The custom LogSubscriber for ActiveRecord.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def strict_loading_violation(event)
        consumer_of(__method__)&.call(Event::StrictLoadingViolation.new(event))
      end

      def sql(event)
        consumer_of(__method__)&.call(Event::Sql.new(event))
      end

      def instantiation(event)
        consumer_of(__method__)&.call(Event::Instantiation.new(event))
      end

      def start_transaction(event)
        consumer_of(__method__)&.call(Event::StartTransaction.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_record"] || consumers[:active_record] || consumers[:default]
      end
    end
  end
end
