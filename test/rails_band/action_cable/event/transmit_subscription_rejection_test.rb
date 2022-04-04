# frozen_string_literal: true

require 'test_helper'

class TransmitSubscriptionRejectionTest < ::ActionCable::Channel::TestCase
  tests ApplicationCable::NiceChannel

  setup do
    @event = nil
    RailsBand::ActionCable::LogSubscriber.consumers = {
      'transmit_subscription_rejection.action_cable': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    subscribe number: '-3'
    assert_equal 'transmit_subscription_rejection.action_cable', @event.name
  end

  test 'returns time' do
    subscribe number: '-3'
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    subscribe number: '-3'
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    subscribe number: '-3'
    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    subscribe number: '-3'
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    subscribe number: '-3'
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    subscribe number: '-3'
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    subscribe number: '-3'
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    subscribe number: '-3'
    %i[name time end transaction_id cpu_time idle_time allocations duration channel_class].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    subscribe number: '-3'
    assert_equal({ name: 'transmit_subscription_rejection.action_cable' }, @event.slice(:name))
  end

  test 'returns an instance of TransmitSubscriptionRejection' do
    subscribe number: '-3'
    assert_instance_of RailsBand::ActionCable::Event::TransmitSubscriptionRejection, @event
  end

  test 'returns channel_class' do
    subscribe number: '-3'
    assert_equal 'ApplicationCable::NiceChannel', @event.channel_class
  end
end
