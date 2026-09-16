# frozen_string_literal: true

require 'test_helper'

class RenderTemplateTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionView::LogSubscriber.consumers = {
      'render_template.action_view': ->(event) { @event = event }
    }
    User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'render_template.action_view'
  end

  def trigger_event
    get '/users'
  end

  test 'calls #to_h' do
    get '/users'

    %i[name time end transaction_id cpu_time idle_time allocations duration identifier layout].each do |key|
      assert_includes @event.to_h, key
    end
    if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
      assert_includes @event.to_h, :locals
    end
  end

  test 'calls #slice' do
    get '/users'

    assert_equal({ name: 'render_template.action_view' }, @event.slice(:name))
  end

  test 'returns an instance of RenderTemplate' do
    get '/users'

    assert_instance_of RailsBand::ActionView::Event::RenderTemplate, @event
  end

  test 'returns identifier' do
    get '/users'

    assert_equal 'users/index.html.erb', @event.identifier
  end

  test 'returns layout' do
    get '/users'

    assert_equal 'layouts/application', @event.layout
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('7.1.0.alpha')
    test 'returns locals' do
      get '/users'

      assert_instance_of Hash, @event.locals
    end
  end
end
