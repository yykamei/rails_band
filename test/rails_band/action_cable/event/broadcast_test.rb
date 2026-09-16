# frozen_string_literal: true

require 'test_helper'

class BroadcastTest < ::ActionCable::Channel::TestCase
  include CommonBaseEventTests

  tests ApplicationCable::NiceChannel

  setup do
    @event = nil
    RailsBand::ActionCable::LogSubscriber.consumers = {
      'broadcast.action_cable': ->(event) { @event = event }
    }
  end

  def event_name
    'broadcast.action_cable'
  end

  def trigger_event
    subscribe number: '2'
    perform :hello, { name: 'J' }
  end

  test 'calls #to_h' do
    subscribe number: '2'
    perform :hello, { name: 'J' }

    %i[name time end transaction_id cpu_time idle_time allocations duration broadcasting message
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
