# frozen_string_literal: true

require 'test_helper'

class PerformActionTest < ::ActionCable::Channel::TestCase
  tests ApplicationCable::NiceChannel

  setup do
    @event = nil
    RailsBand::ActionCable::LogSubscriber.consumers = {
      'perform_action.action_cable': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_equal 'perform_action.action_cable', @event.name
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

    %i[name time end transaction_id cpu_time idle_time allocations duration
       channel_class action data].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_equal({ name: 'perform_action.action_cable' }, @event.slice(:name))
  end

  test 'returns an instance of PerformAction' do
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_instance_of RailsBand::ActionCable::Event::PerformAction, @event
  end

  test 'returns channel_class' do
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_equal 'ApplicationCable::NiceChannel', @event.channel_class
  end

  test 'returns action' do
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_equal :hello, @event.action
  end

  test 'returns data' do
    subscribe number: '2'
    perform :hello, { name: 'J' }

    assert_equal({ 'name' => 'J', 'action' => 'hello' }, @event.data)
  end
end
