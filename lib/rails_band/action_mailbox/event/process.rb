# frozen_string_literal: true

module RailsBand
  module ActionMailbox
    module Event
      # A wrapper for the event that is passed to `process.action_mailbox`.
      class Process < BaseEvent
        def mailbox
          @mailbox ||= @event.payload.fetch(:mailbox)
        end

        def inbound_email
          @inbound_email ||= @event.payload.fetch(:inbound_email)
        end
      end
    end
  end
end
