# frozen_string_literal: true

require 'test_helper'

class StartProcessingTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'start_processing.action_controller': ->(event) { @event = event }
    }
  end

  def event_name
    'start_processing.action_controller'
  end

  def trigger_event
    get '/users'
  end

  test 'calls #to_h' do
    get '/users'

    %i[name time end transaction_id cpu_time idle_time allocations duration controller action params headers
       format method path].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users'

    assert_equal({ name: 'start_processing.action_controller', path: '/users' }, @event.slice(:name, :path))
  end

  test 'returns an instance of StartProcessing' do
    get '/users'

    assert_instance_of RailsBand::ActionController::Event::StartProcessing, @event
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

  if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
    test 'returns request' do
      get '/users'

      assert_instance_of ActionDispatch::Request, @event.request
    end
  else
    test 'raises NoMethodError when accessing request' do
      get '/users'
      assert_raises NoMethodError do
        @event.request
      end
    end
  end
end
