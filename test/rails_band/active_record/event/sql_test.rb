# frozen_string_literal: true

require 'test_helper'

class SqlTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'sql.active_record': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get "/users/#{@user.id}"
    assert_equal 'sql.active_record', @event.name
  end

  test 'returns time' do
    get "/users/#{@user.id}"
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get "/users/#{@user.id}"
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get "/users/#{@user.id}"
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    get "/users/#{@user.id}"
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    get "/users/#{@user.id}"
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get "/users/#{@user.id}"
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get "/users/#{@user.id}"
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get "/users/#{@user.id}"
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    get "/users/#{@user.id}"
    %i[name time end transaction_id children cpu_time idle_time allocations duration sql sql_name binds
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
