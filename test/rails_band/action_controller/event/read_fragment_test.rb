# frozen_string_literal: true

require 'test_helper'

class ReadFragmentTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'read_fragment.action_controller': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'read_fragment.action_controller'
  end

  def trigger_event
    get '/users'
  end

  test 'calls #to_h' do
    get '/users'

    %i[name time end transaction_id cpu_time idle_time allocations duration key].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users'

    assert_equal({ name: 'read_fragment.action_controller' }, @event.slice(:name))
  end

  test 'returns an instance of ReadFragment' do
    get '/users'

    assert_instance_of RailsBand::ActionController::Event::ReadFragment, @event
  end

  test 'returns the cache key' do
    get '/users'

    assert_respond_to @event, :key
  end
end
