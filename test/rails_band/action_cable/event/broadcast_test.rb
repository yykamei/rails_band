# frozen_string_literal: true

require 'test_helper'

class BroadcastTest < ::ActionCable::Channel::TestCase
  tests ApplicationCable::NiceChannel

  setup do
    @event = nil
    RailsBand::ActionCable::LogSubscriber.consumers = {
      'broadcast.action_cable': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_equal 'broadcast.action_cable', @event.name
  end

  test 'returns time' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    %i[name time end transaction_id children cpu_time idle_time allocations duration broadcasting message
       coder].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_equal({ name: 'broadcast.action_cable' }, @event.slice(:name))
  end

  test 'returns an instance of Broadcast' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_instance_of RailsBand::ActionCable::Event::Broadcast, @event
  end

  test 'returns broadcasting' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_equal 'nice_2', @event.broadcasting
  end

  test 'returns message' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_equal({ 'name' => 'J', 'action' => 'hello' }, @event.message)
  end

  test 'returns coder' do
    subscribe number: '2'
    perform :hello, { name: 'J' }
    assert_equal ActiveSupport::JSON, @event.coder
  end
end
