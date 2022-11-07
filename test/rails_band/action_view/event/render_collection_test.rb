# frozen_string_literal: true

require 'test_helper'

class RenderCollectionTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionView::LogSubscriber.consumers = {
      'render_collection.action_view': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
    User.create!(name: 'df', email: 'df@example.com')
  end

  test 'returns name' do
    get '/users'

    assert_equal 'render_collection.action_view', @event.name
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

  test 'calls #to_h' do
    get '/users'

    %i[name time end transaction_id cpu_time idle_time allocations duration identifier layout count
       cache_hits].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get '/users'

    assert_equal({ name: 'render_collection.action_view' }, @event.slice(:name))
  end

  test 'returns an instance of RenderCollection' do
    get '/users'

    assert_instance_of RailsBand::ActionView::Event::RenderCollection, @event
  end

  test 'returns identifier' do
    get '/users'

    assert_equal 'users/_user.html.erb', @event.identifier
  end

  test 'returns layout' do
    get '/users'

    assert_nil @event.layout
  end

  test 'returns count' do
    get '/users'

    assert_equal 2, @event.count
  end

  test 'returns cache_hits' do
    get '/users'

    assert_equal 0, @event.cache_hits
  end
end
