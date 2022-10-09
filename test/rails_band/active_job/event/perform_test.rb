# frozen_string_literal: true

require 'test_helper'

class PerformTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'perform.active_job': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_equal 'perform.active_job', @event.name
  end

  test 'returns time' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    %i[name time end transaction_id cpu_time idle_time allocations duration adapter job].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_equal({ name: 'perform.active_job' }, @event.slice(:name))
  end

  test 'returns an instance of Perform' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of RailsBand::ActiveJob::Event::Perform, @event
  end

  test 'returns adapter' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of ::ActiveJob::QueueAdapters::TestAdapter, @event.adapter
  end

  test 'returns job' do
    YayJob.perform_now(name: 'JJ', message: 'Hi')
    assert_instance_of YayJob, @event.job
    assert_equal [{ name: 'JJ', message: 'Hi' }], @event.job.arguments
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
    test 'returns aborted' do
      YayJob.perform_now(name: 'JJ', message: 'Hi', aborted: true)
      assert @event.aborted
    end

    test 'returns db_runtime' do
      YayJob.perform_now(name: 'JJ', message: 'Hi')
      assert_instance_of Float, @event.db_runtime
    end
  end
end
