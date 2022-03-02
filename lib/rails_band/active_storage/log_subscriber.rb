# frozen_string_literal: true

require 'rails_band/active_storage/event/service_upload'
require 'rails_band/active_storage/event/service_streaming_download'
require 'rails_band/active_storage/event/service_download_chunk'
require 'rails_band/active_storage/event/service_download'
require 'rails_band/active_storage/event/service_delete'

module RailsBand
  module ActiveStorage
    # The custom LogSubscriber for ActiveStorage.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def service_upload(event)
        consumer_of(__method__)&.call(Event::ServiceUpload.new(event))
      end

      def service_streaming_download(event)
        consumer_of(__method__)&.call(Event::ServiceStreamingDownload.new(event))
      end

      def service_download_chunk(event)
        consumer_of(__method__)&.call(Event::ServiceDownloadChunk.new(event))
      end

      def service_download(event)
        consumer_of(__method__)&.call(Event::ServiceDownload.new(event))
      end

      def service_delete(event)
        consumer_of(__method__)&.call(Event::ServiceDelete.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.active_storage"] || consumers[:active_storage] || consumers[:default]
      end
    end
  end
end
