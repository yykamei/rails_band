# frozen_string_literal: true

require 'test_helper'

class SendFileTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'send_file.action_controller': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get '/users/123/file'
    assert_equal 'send_file.action_controller', @event.name
  end

  test 'returns time' do
    get '/users/123/file'
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get '/users/123/file'
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get '/users/123/file'
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    get '/users/123/file'
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    get '/users/123/file'
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get '/users/123/file'
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get '/users/123/file'
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get '/users/123/file'
    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    get '/users/123/file'
    %i[name time end transaction_id children cpu_time idle_time allocations duration
       path filename type disposition status].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users/123/file'
    assert_equal({ name: 'send_file.action_controller' }, @event.slice(:name))
  end

  test 'returns an instance of SendFile' do
    get '/users/123/file'
    assert_instance_of RailsBand::ActionController::Event::SendFile, @event
  end

  test 'returns the sent file path' do
    get '/users/123/file'
    assert_instance_of Pathname, @event.path
    assert_equal Rails.root.join('public/404.html').to_path, @event.path.to_path
  end

  test 'returns filename' do
    get '/users/123/file'
    assert_equal 'power.html', @event.filename
  end

  test 'returns type' do
    get '/users/123/file'
    assert_nil @event.type
  end

  test 'returns disposition' do
    get '/users/123/file'
    assert_nil @event.disposition
  end

  test 'returns status' do
    get '/users/123/file'
    assert_nil @event.status
  end

  test 'returns url_based_filename' do
    get '/users/123/file'
    assert_nil @event.url_based_filename
  end
end
