# frozen_string_literal: true

module RailsBand
  module ActionMailer
    module Event
      # A wrapper for the event that is passed to `deliver.action_mailer`.
      class Deliver < BaseEvent
        def mailer
          @mailer ||= @event.payload.fetch(:mailer)
        end

        def message_id
          @message_id ||= @event.payload.fetch(:message_id)
        end

        def subject
          @subject ||= @event.payload.fetch(:subject)
        end

        def to
          @to ||= @event.payload.fetch(:to)
        end

        def from
          @from ||= @event.payload.fetch(:from)
        end

        def bcc
          @bcc ||= @event.payload[:bcc] || []
        end

        def cc
          @cc ||= @event.payload[:cc] || []
        end

        def date
          @date ||= @event.payload.fetch(:date)
        end

        def mail
          @mail ||= @event.payload.fetch(:mail)
        end

        def perform_deliveries
          @perform_deliveries ||= @event.payload.fetch(:perform_deliveries)
        end
      end
    end
  end
end
