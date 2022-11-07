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
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_equal 'unpermitted_parameters.action_controller', @event.name
  end

  test 'returns time' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    %i[name time end transaction_id cpu_time idle_time allocations duration keys].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_equal({ name: 'unpermitted_parameters.action_controller' }, @event.slice(:name))
  end

  test 'returns an instance of UnpermittedParameters' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_instance_of RailsBand::ActionController::Event::UnpermittedParameters, @event
  end

  test 'returns keys' do
    patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

    assert_equal %w[nickname login_shell id], @event.keys
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
    test 'returns controller' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

      assert_equal 'UsersController', @event.controller
    end
  else
    test 'raises NoMethodError when accessing controller' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }
      assert_raises NoMethodError do
        @event.controller
      end
    end
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
    test 'returns action' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

      assert_equal 'update', @event.action
    end
  else
    test 'raises NoMethodError when accessing action' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }
      assert_raises NoMethodError do
        @event.action
      end
    end
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
    test 'returns request' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

      assert_instance_of ActionDispatch::Request, @event.request
    end
  else
    test 'raises NoMethodError when accessing request' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }
      assert_raises NoMethodError do
        @event.request
      end
    end
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
    test 'returns params' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }

      assert_equal({ name: 'foo!', nickname: 'F', login_shell: 'zsh', controller: 'users', action: 'update', id: '1' },
                   @event.params.symbolize_keys)
    end
  else
    test 'raises NoMethodError when accessing params' do
      patch "/users/#{@user.id}", params: { name: 'foo!', nickname: 'F', login_shell: 'zsh' }
      assert_raises NoMethodError do
        @event.params
      end
    end
  end
end
