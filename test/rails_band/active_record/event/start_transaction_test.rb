# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.2')
  class StartTransactionTest < ActionDispatch::IntegrationTest
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveRecord::LogSubscriber.consumers = {
        'start_transaction.active_record': ->(event) { @event = event }
      }
      @user = User.create!(name: 'foo', email: 'foo@example.com')
    end

    def event_name
      'start_transaction.active_record'
    end

    def trigger_event
      User.transaction { @user.update!(name: 'bar') }
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
end
