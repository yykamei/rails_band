# frozen_string_literal: true

require 'test_helper'

class SendDataTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'send_data.action_controller': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'send_data.action_controller'
  end

  def trigger_event
    get '/users/123/data'
  end

  test 'calls #to_h' do
    get '/users/123/data'

    %i[name time end transaction_id cpu_time idle_time allocations duration
       filename type disposition status].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/data'

    assert_equal({ name: 'send_data.action_controller' }, @event.slice(:name))
  end

  test 'returns an instance of SendData' do
    get '/users/123/data'

    assert_instance_of RailsBand::ActionController::Event::SendData, @event
  end

  test 'returns filename' do
    get '/users/123/data'

    assert_equal 'power.html', @event.filename
  end

  test 'returns type' do
    get '/users/123/data'

    assert_nil @event.type
  end

  test 'returns disposition' do
    get '/users/123/data'

    assert_nil @event.disposition
  end

  test 'returns status' do
    get '/users/123/data'

    assert_equal 201, @event.status
  end
end
