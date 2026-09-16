# frozen_string_literal: true

require 'test_helper'

class DeliverTest < ActionDispatch::IntegrationTest
  include CommonBaseEventTests

  setup do
    @event = nil
    RailsBand::ActionMailer::LogSubscriber.consumers = {
      'deliver.action_mailer': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  def event_name
    'deliver.action_mailer'
  end

  def trigger_event
    get "/users/#{@user.id}/welcome_email"
  end

  test 'calls #to_h' do
    get "/users/#{@user.id}/welcome_email"

    %i[name time end transaction_id cpu_time idle_time allocations duration mailer message_id
       subject to from bcc cc date mail perform_deliveries].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal({ name: 'deliver.action_mailer' }, @event.slice(:name))
  end

  test 'returns an instance of Deliver' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of RailsBand::ActionMailer::Event::Deliver, @event
  end

  test 'returns mailer' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal 'WelcomeMailer', @event.mailer
  end

  test 'returns message_id' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of String, @event.message_id
  end

  test 'returns subject' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal 'Hi, welcome!', @event.subject
  end

  test 'returns to' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal [@user.email], @event.to
  end

  test 'returns from' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal %w[from@example.com], @event.from
  end

  test 'returns bcc' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal %w[system@example.com], @event.bcc
  end

  test 'returns cc' do
    get "/users/#{@user.id}/welcome_email"

    assert_equal [], @event.cc
  end

  test 'returns date' do
    get "/users/#{@user.id}/welcome_email"

    assert_instance_of DateTime, @event.date
  end

  test 'returns mail' do
    get "/users/#{@user.id}/welcome_email"

    assert_match(/Hi, foo/, @event.mail)
  end

  test 'returns perform_deliveries' do
    get "/users/#{@user.id}/welcome_email"

    assert @event.perform_deliveries
  end
end
