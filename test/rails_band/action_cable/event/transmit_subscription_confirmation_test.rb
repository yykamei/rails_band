# frozen_string_literal: true

require 'test_helper'

class TransmitSubscriptionConfirmationTest < ::ActionCable::Channel::TestCase
  include CommonBaseEventTests

  tests ApplicationCable::NiceChannel

  setup do
    @event = nil
    RailsBand::ActionCable::LogSubscriber.consumers = {
      'transmit_subscription_confirmation.action_cable': ->(event) { @event = event }
    }
  end

  def event_name
    'transmit_subscription_confirmation.action_cable'
  end

  def trigger_event
    subscribe number: '2'
    perform :call_transmit, { name: 'J' }
  end

  test 'calls #to_h' do
    subscribe number: '2'
    perform :call_transmit, { name: 'J' }

    %i[name time end transaction_id cpu_time idle_time allocations duration channel_class].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    subscribe number: '2'
    perform :call_transmit, { name: 'J' }

    assert_equal({ name: 'transmit_subscription_confirmation.action_cable' }, @event.slice(:name))
  end

  test 'returns an instance of TransmitSubscriptionConfirmation' do
    subscribe number: '2'
    perform :call_transmit, { name: 'J' }

    assert_instance_of RailsBand::ActionCable::Event::TransmitSubscriptionConfirmation, @event
  end

  test 'returns channel_class' do
    subscribe number: '2'
    perform :call_transmit, { name: 'J' }

    assert_equal 'ApplicationCable::NiceChannel', @event.channel_class
  end
end
