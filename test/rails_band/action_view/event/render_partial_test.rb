# frozen_string_literal: true

require 'test_helper'

class RenderPartialTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionView::LogSubscriber.consumers = {
      'render_partial.action_view': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get "/users/#{@user.id}"
    assert_equal 'render_partial.action_view', @event.name
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
    %i[name time end transaction_id cpu_time idle_time allocations duration identifier layout
       cache_hit].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get "/users/#{@user.id}"
    assert_equal({ name: 'render_partial.action_view' }, @event.slice(:name))
  end

  test 'returns an instance of RenderPartial' do
    get "/users/#{@user.id}"
    assert_instance_of RailsBand::ActionView::Event::RenderPartial, @event
  end

  test 'returns identifier' do
    get "/users/#{@user.id}"
    assert_equal 'users/_user.html.erb', @event.identifier
  end

  test 'returns layout' do
    get "/users/#{@user.id}"
    assert_nil @event.layout
  end

  test 'returns cache_hit' do
    get "/users/#{@user.id}"
    assert_equal :miss, @event.cache_hit
  end
end
