# frozen_string_literal: true

require 'test_helper'

class ProcessMiddlewareTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionDispatch::LogSubscriber.consumers = {
      'process_middleware.action_dispatch': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'process_middleware.action_dispatch'
  end

  def trigger_event
    get '/users'
  end

  test 'calls #to_h' do
    get '/users'

    %i[name time end transaction_id cpu_time idle_time allocations duration middleware].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users'

    assert_equal({ name: 'process_middleware.action_dispatch' }, @event.slice(:name))
  end

  test 'returns an instance of ProcessMiddleware' do
    get '/users'

    assert_instance_of RailsBand::ActionDispatch::Event::ProcessMiddleware, @event
  end

  test 'returns the middleware' do
    get '/users'

    assert_respond_to @event, :middleware
  end
end
