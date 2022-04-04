# frozen_string_literal: true

require 'test_helper'

class RedirectToTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'redirect_to.action_controller': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get '/users/123/redirect'
    assert_equal 'redirect_to.action_controller', @event.name
  end

  test 'returns time' do
    get '/users/123/redirect'
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get '/users/123/redirect'
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get '/users/123/redirect'
    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    get '/users/123/redirect'
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get '/users/123/redirect'
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get '/users/123/redirect'
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get '/users/123/redirect'
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    get '/users/123/redirect'
    %i[name time end transaction_id cpu_time idle_time allocations duration
       status location].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/redirect'
    assert_equal({ name: 'redirect_to.action_controller', status: 302 }, @event.slice(:name, :status))
  end

  test 'returns an instance of RedirectTo' do
    get '/users/123/redirect'
    assert_instance_of RailsBand::ActionController::Event::RedirectTo, @event
  end

  test 'returns status' do
    get '/users/123/redirect'
    assert_equal 302, @event.status
  end

  test 'returns location' do
    get '/users/123/redirect'
    assert_equal 'http://www.example.com/users', @event.location
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
    test 'returns request' do
      get '/users/123/redirect'
      assert_instance_of ActionDispatch::Request, @event.request
    end
  else
    test 'raises NoMethodError when accessing request' do
      get '/users/123/redirect'
      assert_raises NoMethodError do
        @event.request
      end
    end
  end
end
