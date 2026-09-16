# frozen_string_literal: true

require 'test_helper'

class ProcessTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionMailer::LogSubscriber.consumers = {
      'process.action_mailer': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'process.action_mailer'
  end

  def trigger_event
    get "/users/#{@user.id}/welcome_email"
  end

  test 'calls #to_h' do
    get "/users/#{@user.id}/welcome_email"

    %i[name time end transaction_id cpu_time idle_time allocations duration mailer action args].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal({ name: 'process.action_mailer' }, @event.slice(:name))
  end

  test 'returns an instance of Process' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of RailsBand::ActionMailer::Event::Process, @event
  end

  test 'returns mailer' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal 'WelcomeMailer', @event.mailer
  end

  test 'returns action' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal :hi, @event.action
  end

  test 'returns args' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal [], @event.args
  end
end
