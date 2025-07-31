# frozen_string_literal: true

require 'test_helper'

class StartTransactionTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'start_transaction.active_record': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    User.transaction { @user.update!(name: 'bar') }

    assert_equal 'start_transaction.active_record', @event.name
  end

  test 'returns time' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    User.transaction { @user.update!(name: 'bar') }

    %i[name time end transaction_id cpu_time idle_time allocations duration transaction connection].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    User.transaction { @user.update!(name: 'bar') }

    assert_equal({ name: 'start_transaction.active_record' }, @event.slice(:name))
  end

  test 'returns an instance of StartTransaction' do
    User.transaction { @user.update!(name: 'bar') }

    assert_instance_of RailsBand::ActiveRecord::Event::StartTransaction, @event
  end

  test 'returns transaction' do
    User.transaction { @user.update!(name: 'bar') }

    assert @event.transaction
  end

  test 'returns connection' do
    User.transaction { @user.update!(name: 'bar') }

    assert @event.connection
  end
end
