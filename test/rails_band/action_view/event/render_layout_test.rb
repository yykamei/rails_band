# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
  class RenderLayoutTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActionView::LogSubscriber.consumers = {
        'render_layout.action_view': ->(event) { @event = event }
      }
      User.create!(name: 'foo', email: 'foo@example.com')
      User.create!(name: 'df', email: 'df@example.com')
    end

    test 'returns name' do
      get '/users'
      assert_equal 'render_layout.action_view', @event.name
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
      %i[name time end transaction_id cpu_time idle_time allocations duration identifier].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get '/users'
      assert_equal({ name: 'render_layout.action_view' }, @event.slice(:name))
    end

    test 'returns an instance of RenderLayout' do
      get '/users'
      assert_instance_of RailsBand::ActionView::Event::RenderLayout, @event
    end

    test 'returns identifier' do
      get '/users'
      assert_equal 'layouts/application.html.erb', @event.identifier
    end
  end
end
