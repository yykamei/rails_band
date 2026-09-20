# frozen_string_literal: true

require 'test_helper'

if defined?(ActiveJob::Continuable)
  class StepTest < ActiveSupport::TestCase
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'step.active_job': ->(event) { @event = event }
      }
      InterruptJob.runs = 0
    end

    def event_name
      'step.active_job'
    end

    def trigger_event
      InterruptJob.perform_now
    end

    test 'calls #to_h' do
      trigger_event

      %i[name time end transaction_id cpu_time idle_time allocations duration adapter job step
         interrupted].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_event

      assert_equal({ name: 'step.active_job' }, @event.slice(:name))
    end

    test 'returns an instance of Step' do
      trigger_event

      assert_instance_of RailsBand::ActiveJob::Event::Step, @event
    end

    test 'returns adapter' do
      trigger_event

      assert_instance_of ActiveJob::QueueAdapters::TestAdapter, @event.adapter
    end

    test 'returns job' do
      trigger_event

      assert_instance_of InterruptJob, @event.job
    end

    test 'returns step' do
      trigger_event

      assert_instance_of ActiveJob::Continuation::Step, @event.step
    end

    test 'returns interrupted as true when the step is interrupted' do
      trigger_event

      assert @event.interrupted
    end

    test 'returns interrupted as false when the step is not interrupted' do
      events = []
      RailsBand::ActiveJob::LogSubscriber.consumers = {
        'step.active_job': ->(event) { events << event }
      }
      interrupted = InterruptJob.new
      interrupted.perform_now
      resumed = InterruptJob.deserialize(interrupted.serialize)
      resumed.perform_now

      assert_equal false, events.last.interrupted
    end
  end
end
