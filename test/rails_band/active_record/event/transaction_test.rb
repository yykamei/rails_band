# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('7.2')
  class TransactionTest < ActionDispatch::IntegrationTest
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveRecord::LogSubscriber.consumers = {
        'transaction.active_record': ->(event) { @event = event }
      }
      @user = User.create!(name: 'foo', email: 'foo@example.com')
    end

    def event_name
      'transaction.active_record'
    end

    def trigger_event
      User.transaction { @user.update!(name: 'bar') }
    end

    test 'calls #to_h' do
      trigger_event

      %i[name time end transaction_id cpu_time idle_time allocations duration transaction outcome
         connection].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_event

      assert_equal({ name: 'transaction.active_record' }, @event.slice(:name))
    end

    test 'returns an instance of Transaction' do
      trigger_event

      assert_instance_of RailsBand::ActiveRecord::Event::Transaction, @event
    end

    test 'returns transaction' do
      trigger_event

      assert @event.transaction
    end

    test 'returns outcome' do
      trigger_event

      assert_equal :commit, @event.outcome
    end

    test 'returns connection' do
      trigger_event

      assert @event.connection
    end

    test 'returns rollback as outcome when the transaction is rolled back' do
      User.transaction do
        @user.update!(name: 'baz')
        raise ActiveRecord::Rollback
      end

      # The consumer captures the last event; no other `transaction.active_record`
      # event fires between the rollback and this assertion.
      assert_equal :rollback, @event.outcome
    end
  end
end
