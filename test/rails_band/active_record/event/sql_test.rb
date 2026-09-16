# frozen_string_literal: true

require 'test_helper'

class SqlTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'sql.active_record': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'sql.active_record'
  end

  def trigger_event
    get "/users/#{@user.id}"
  end

  test 'calls #to_h' do
    get "/users/#{@user.id}"

    %i[name time end transaction_id cpu_time idle_time allocations duration sql sql_name binds
       type_casted_binds connection statement_name async cached].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get "/users/#{@user.id}"

    assert_equal({ name: 'sql.active_record' }, @event.slice(:name))
  end

  test 'returns an instance of Sql' do
    get "/users/#{@user.id}"

    assert_instance_of RailsBand::ActiveRecord::Event::Sql, @event
  end

  test 'returns sql' do
    get "/users/#{@user.id}"

    assert_instance_of String, @event.sql
  end

  test 'returns sql_name' do
    get "/users/#{@user.id}"

    assert_instance_of String, @event.sql_name
  end

  test 'returns binds' do
    get "/users/#{@user.id}"

    assert_respond_to @event, :binds
  end

  test 'returns type_casted_binds' do
    get "/users/#{@user.id}"

    assert_respond_to @event, :type_casted_binds
  end

  test 'returns connection' do
    get "/users/#{@user.id}"

    assert_respond_to @event, :connection
  end

  test 'returns statement_name' do
    get "/users/#{@user.id}"

    assert_respond_to @event, :statement_name
  end

  test 'returns async' do
    get "/users/#{@user.id}"

    assert_respond_to @event, :async
  end

  test 'returns cached' do
    get "/users/#{@user.id}"

    refute @event.cached
  end
end
