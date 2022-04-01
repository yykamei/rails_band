# frozen_string_literal: true

module RailsBand
  # DeprecationSubscriber is responsible for logging deprecation warnings.
  class DeprecationSubscriber < ::ActiveSupport::LogSubscriber
    # DeprecationEvent is a wrapper around a deprecation notification event.
    class DeprecationEvent < BaseEvent
      def message
        @message ||= @event.payload.fetch(:message)
      end

      def callstack
        @callstack ||= @event.payload.fetch(:callstack)
      end

      def gem_name
        @gem_name ||= @event.payload.fetch(:gem_name)
      end

      def deprecation_horizon
        @deprecation_horizon ||= @event.payload.fetch(:deprecation_horizon)
      end
    end

    mattr_accessor :consumers

    def deprecation(event)
      consumer&.call(DeprecationEvent.new(event))
    end

    private

    def consumer
      # HACK: ActiveSupport::Subscriber has the instance variable @namespace, but it's not documented.
      #       This hack might possibly break in the future.
      namespace = self.class.instance_variable_get(:@namespace)
      consumers[:"deprecation.#{namespace}"] || consumers[:deprecation] || consumers[:default]
    end
  end
end
