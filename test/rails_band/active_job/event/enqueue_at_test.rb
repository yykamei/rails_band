# frozen_string_literal: true

require 'test_helper'

class EnqueueAtTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveJob::LogSubscriber.consumers = {
      'enqueue_at.active_job': ->(event) { @event = event }
    }
  end

  def event_name
    'enqueue_at.active_job'
  end

  def trigger_event
    get '/yay'
  end

  test 'calls #to_h' do
    get '/yay'

    %i[name time end transaction_id cpu_time idle_time allocations duration adapter job].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/yay'

    assert_equal({ name: 'enqueue_at.active_job' }, @event.slice(:name))
  end

  test 'returns an instance of EnqueueAt' do
    get '/yay'

    assert_instance_of RailsBand::ActiveJob::Event::EnqueueAt, @event
  end

  test 'returns adapter' do
    get '/yay'

    assert_instance_of ::ActiveJob::QueueAdapters::TestAdapter, @event.adapter
  end

  test 'returns job' do
    get '/yay'

    assert_instance_of YayJob, @event.job
    assert_equal [{ name: 'foo', message: 'Hi' }], @event.job.arguments
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
    test 'returns aborted' do
      get '/yay?aborted=true'

      assert @event.aborted
    end
  end
end
