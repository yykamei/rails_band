# frozen_string_literal: true

require 'rails_band/active_storage/event/service_upload'

module RailsBand
  module ActiveStorage
    # The custom LogSubscriber for ActiveStorage.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def service_upload(event)
        consumer_of(__method__)&.call(Event::ServiceUpload.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_storage"] || consumers[:active_storage] || consumers[:default]
      end
    end
  end
end