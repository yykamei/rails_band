# frozen_string_literal: true

require 'test_helper'

class InstantiationTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'instantiation.active_record': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get "/users/#{@user.id}"
    assert_equal 'instantiation.active_record', @event.name
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
    %i[name time end transaction_id children cpu_time idle_time allocations duration record_count class_name].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get "/users/#{@user.id}"
    assert_equal({ name: 'instantiation.active_record' }, @event.slice(:name))
  end

  test 'returns an instance of Instantiation' do
    get "/users/#{@user.id}"
    assert_instance_of RailsBand::ActiveRecord::Event::Instantiation, @event
  end

  test 'returns record_count' do
    get "/users/#{@user.id}"
    assert_equal 1, @event.record_count
  end

  test 'returns class_name' do
    get "/users/#{@user.id}"
    assert_equal 'User', @event.class_name
  end
end
