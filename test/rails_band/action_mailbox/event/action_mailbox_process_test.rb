# frozen_string_literal: true

require 'test_helper'

class ActionMailboxProcessTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionMailbox::LogSubscriber.consumers = {
      'process.action_mailbox': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get "/users/#{@user.id}/mailbox"

    assert_equal 'process.action_mailbox', @event.name
  end

  test 'returns time' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    get "/users/#{@user.id}/mailbox"

    %i[name time end transaction_id cpu_time idle_time allocations duration mailbox inbound_email].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get "/users/#{@user.id}/mailbox"

    assert_equal({ name: 'process.action_mailbox' }, @event.slice(:name))
  end

  test 'returns an instance of Process' do
    get "/users/#{@user.id}/mailbox"

    assert_instance_of RailsBand::ActionMailbox::Event::Process, @event
  end

  test 'returns mailbox' do
    get "/users/#{@user.id}/mailbox"

    assert @event.mailbox
  end

  test 'returns inbound_email' do
    get "/users/#{@user.id}/mailbox"

    assert_equal({ id: 3, message_id: 'mid', status: 'processing' }, @event.inbound_email)
  end
end
