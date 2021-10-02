# frozen_string_literal: true

require 'test_helper'

class ProcessActionTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'process_action.action_controller': ->(event) { @event = event }
    }
  end

  test 'returns name' do
    get '/users'
    assert_equal 'process_action.action_controller', @event.name
  end

  test 'returns time' do
    get '/users'
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get '/users'
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get '/users'
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    get '/users'
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    get '/users'
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get '/users'
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get '/users'
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get '/users'
    assert_instance_of Float, @event.duration
  end

  test 'returns an instance of ProcessAction' do
    get '/users'
    assert_instance_of RailsBand::ActionController::Event::ProcessAction, @event
  end

  test 'returns the controller name' do
    get '/users'
    assert_equal 'UsersController', @event.controller
  end

  test 'returns the action name' do
    get '/users'
    assert_equal 'index', @event.action
  end

  test 'returns params' do
    get '/users?abc=123&ok[]=a&ok[]=b'
    assert_equal({ 'abc' => '123', 'ok' => %w[a b] }, @event.params)
  end

  test 'returns headers' do
    get '/users', headers: { 'X-Foo' => 'Foo!' }
    assert_instance_of ActionDispatch::Http::Headers, @event.headers
    assert_equal 'Foo!', @event.headers.fetch('X-Foo')
  end

  test 'returns format' do
    get '/users'
    assert_equal :html, @event.format
  end

  test 'returns method' do
    get '/users'
    assert_equal 'GET', @event.method
  end

  test 'returns path' do
    get '/users?abc=123'
    assert_equal '/users', @event.path
  end

  test 'returns status' do
    get '/users'
    assert_equal 200, @event.status
  end

  test 'returns status with 500' do
    assert_raises RuntimeError do
      get '/users/1234/flawed'
    end
    assert_equal '/users/1234/flawed', @event.path
    assert_equal 500, @event.status
  end

  test 'returns view_runtime' do
    get '/users'
    assert_instance_of Float, @event.view_runtime
  end

  test 'returns request' do
    get '/users'
    assert_instance_of ActionDispatch::Request, @event.request
  end

  test 'returns response' do
    get '/users'
    assert_instance_of ActionDispatch::Response, @event.response
  end

  test 'returns db_runtime' do
    get '/users'
    assert_instance_of Float, @event.db_runtime
  end
end
