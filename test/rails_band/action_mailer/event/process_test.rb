# frozen_string_literal: true

require 'test_helper'

class ProcessTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionMailer::LogSubscriber.consumers = {
      'process.action_mailer': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal 'process.action_mailer', @event.name
  end

  test 'returns time' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of Float, @event.duration
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
