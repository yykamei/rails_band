# frozen_string_literal: true

module RailsBand
  module ActiveRecord
    module Event
      # A wrapper for the event that is passed to `transaction.active_record`.
      class Transaction < BaseEvent
        # The `:transaction` key was added in Rails 7.2. It is absent on Rails 7.1,
        # where this event is also emitted with only `:connection` and `:outcome`.
        def transaction
          @transaction ||= @event.payload[:transaction]
        end

        def outcome
          @outcome ||= @event.payload.fetch(:outcome)
        end

        def connection
          @connection ||= @event.payload.fetch(:connection)
        end
      end
    end
  end
end
