# frozen_string_literal: true

module RailsBand
  # The base class of each Event class.
  class BaseEvent
    attr_reader :name, :time, :end, :transaction_id, :children,
                :cpu_time, :idle_time, :allocations, :duration

    # @param event [ActiveSupport::Notifications::Event]
    def initialize(event)
      @event = event
      @name = event.name
      @time = event.time
      @end = event.end
      @transaction_id = event.transaction_id
      @children = event.children
      @cpu_time = event.cpu_time
      @idle_time = event.idle_time
      @allocations = event.allocations
      @duration = event.duration
    end
  end
end
