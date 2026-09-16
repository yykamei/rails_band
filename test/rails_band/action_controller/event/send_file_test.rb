# frozen_string_literal: true

require 'test_helper'

class SendFileTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'send_file.action_controller': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'send_file.action_controller'
  end

  def trigger_event
    get '/users/123/file'
  end

  test 'calls #to_h' do
    get '/users/123/file'

    %i[name time end transaction_id cpu_time idle_time allocations duration
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
