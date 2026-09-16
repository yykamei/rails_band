# frozen_string_literal: true

require 'test_helper'

class InstantiationTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActiveRecord::LogSubscriber.consumers = {
      'instantiation.active_record': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'instantiation.active_record'
  end

  def trigger_event
    get "/users/#{@user.id}"
  end

  test 'calls #to_h' do
    get "/users/#{@user.id}"

    %i[name time end transaction_id cpu_time idle_time allocations duration record_count
       class_name].each do |key|
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
