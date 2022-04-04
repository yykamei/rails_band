# frozen_string_literal: true

module RailsBand
  # The base class of each Event class.
  class BaseEvent
    attr_reader :name, :time, :end, :transaction_id,
                :cpu_time, :idle_time, :allocations, :duration

    # @param event [ActiveSupport::Notifications::Event]
    def initialize(event)
      @event = event
      @name = event.name
      @time = event.time
      @end = event.end
      @transaction_id = event.transaction_id
      @cpu_time = event.cpu_time
      @idle_time = event.idle_time
      @allocations = event.allocations
      @duration = event.duration
    end

    def to_h
      @to_h ||= {
        name: @name, time: @time, end: @end, transaction_id: @transaction_id,
        cpu_time: @cpu_time, idle_time: @idle_time, allocations: @allocations, duration: @duration
      }.merge!(
        public_methods(false).reject { |meth| non_hash_keys.include?(meth) }.each_with_object({}) do |meth, h|
          h[meth] = public_send(meth)
        end
      )
    end

    def slice(*args)
      to_h.slice(*args)
    end

    private

    def non_hash_keys
      @non_hash_keys ||= []
    end
  end
end
