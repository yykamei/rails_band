# frozen_string_literal: true

require 'test_helper'

class UnpermittedParametersTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActionController::LogSubscriber.consumers = {
      'unpermitted_parameters.action_controller': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_equal 'unpermitted_parameters.action_controller', @event.name
  end

  test 'returns time' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of String, @event.transaction_id
  end

  test 'returns children' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of Array, @event.children
  end

  test 'returns cpu_time' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of Float, @event.duration
  end

  test 'returns an instance of UnpermittedParameters' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_instance_of RailsBand::ActionController::Event::UnpermittedParameters, @event
  end

  test 'returns keys' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_equal %w[nickname login_shell], @event.keys
  end

  test 'returns controller' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_respond_to @event, :controller
  end

  test 'returns action' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_respond_to @event, :action
  end

  test 'returns request' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_respond_to @event, :request
  end

  test 'returns params' do
    patch "/users/#{@user.id}", params: { user: { name: 'foo!', nickname: 'F', login_shell: 'zsh' } }
    assert_respond_to @event, :params
  end
end
