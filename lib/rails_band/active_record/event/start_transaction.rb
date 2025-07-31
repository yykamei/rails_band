# frozen_string_literal: true

module RailsBand
  module ActiveRecord
    module Event
      # A wrapper for the event that is passed to `start_transaction.active_record`.
      class StartTransaction < BaseEvent
        def transaction
          @transaction ||= @event.payload.fetch(:transaction)
        end

        def connection
          @connection ||= @event.payload.fetch(:connection)
        end
      end
    end
  end
end
