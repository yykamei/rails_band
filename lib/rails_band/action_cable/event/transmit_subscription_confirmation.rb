# frozen_string_literal: true

module RailsBand
  module ActionCable
    module Event
      # A wrapper for the event that is passed to `transmit_subscription_confirmation.action_cable`.
      class TransmitSubscriptionConfirmation < BaseEvent
        def channel_class
          @channel_class ||= @event.payload.fetch(:channel_class)
        end
      end
    end
  end
end
