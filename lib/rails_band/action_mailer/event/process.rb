# frozen_string_literal: true

module RailsBand
  module ActionMailer
    module Event
      # A wrapper for the event that is passed to `process.action_mailer`.
      class Process < BaseEvent
        def mailer
          @mailer ||= @event.payload.fetch(:mailer)
        end

        def action
          @action ||= @event.payload.fetch(:action)
        end

        def args
          @args ||= @event.payload.fetch(:args)
        end
      end
    end
  end
end
