# frozen_string_literal: true

require 'rails_band/action_controller/event/write_fragment'
require 'rails_band/action_controller/event/read_fragment'
require 'rails_band/action_controller/event/expire_fragment'
require 'rails_band/action_controller/event/exist_fragment'
require 'rails_band/action_controller/event/start_processing'
require 'rails_band/action_controller/event/process_action'
require 'rails_band/action_controller/event/send_file'
require 'rails_band/action_controller/event/send_data'
require 'rails_band/action_controller/event/redirect_to'
require 'rails_band/action_controller/event/halted_callback'
require 'rails_band/action_controller/event/unpermitted_parameters'

module RailsBand
  module ActionController
    # This comes from ::ActionController::LogSubscriber
    # @see https://github.com/rails/rails/blob/53000f3a2df5c59252d019bbb8d46728b291ec74/actionpack/lib/action_controller/log_subscriber.rb#L5
    INTERNAL_PARAMS = %w[controller action format _method only_path].freeze

    # The custom LogSubscriber for ActionController.
    class LogSubscriber < ::ActiveSupport::LogSubscriber
      mattr_accessor :consumers

      def write_fragment(event)
        consumer_of(__method__)&.call(Event::WriteFragment.new(event))
      end

      def read_fragment(event)
        consumer_of(__method__)&.call(Event::ReadFragment.new(event))
      end

      def expire_fragment(event)
        consumer_of(__method__)&.call(Event::ExpireFragment.new(event))
      end

      def exist_fragment?(event)
        consumer_of(__method__)&.call(Event::ExistFragment.new(event))
      end

      def start_processing(event)
        consumer_of(__method__)&.call(Event::StartProcessing.new(event))
      end

      def process_action(event)
        consumer_of(__method__)&.call(Event::ProcessAction.new(event))
      end

      def send_file(event)
        consumer_of(__method__)&.call(Event::SendFile.new(event))
      end

      def send_data(event)
        consumer_of(__method__)&.call(Event::SendData.new(event))
      end

      def redirect_to(event)
        consumer_of(__method__)&.call(Event::RedirectTo.new(event))
      end

      def halted_callback(event)
        consumer_of(__method__)&.call(Event::HaltedCallback.new(event))
      end

      def unpermitted_parameters(event)
        consumer_of(__method__)&.call(Event::UnpermittedParameters.new(event))
      end

      private

      def consumer_of(sub_event)
        consumers[:"#{sub_event}.action_controller"] || consumers[:action_controller] || consumers[:default]
      end
    end
  end
end
