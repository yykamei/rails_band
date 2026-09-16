# frozen_string_literal: true

require 'test_helper'

class RenderCollectionTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionView::LogSubscriber.consumers = {
      'render_collection.action_view': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
    User.create!(name: 'df', email: 'df@example.com')
  end

  def event_name
    'render_collection.action_view'
  end

  def trigger_event
    get '/users'
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
