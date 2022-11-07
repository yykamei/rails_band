# frozen_string_literal: true

require 'test_helper'

class CacheGenerateTest < ActionDispatch::IntegrationTest
  setup do
    @event = nil
    RailsBand::ActiveSupport::LogSubscriber.consumers = {
      'cache_generate.active_support': ->(event) { @event = event }
    }
    @user = User.create!(name: 'foo', email: 'foo@example.com')
  end

  test 'returns name' do
    get "/users/#{@user.id}/cache"

    assert_equal 'cache_generate.active_support', @event.name
  end

  test 'returns time' do
    get "/users/#{@user.id}/cache"

    assert_instance_of Float, @event.time
  end

  test 'returns end' do
    get "/users/#{@user.id}/cache"

    assert_instance_of Float, @event.end
  end

  test 'returns transaction_id' do
    get "/users/#{@user.id}/cache"

    assert_instance_of String, @event.transaction_id
  end

  test 'returns cpu_time' do
    get "/users/#{@user.id}/cache"

    assert_instance_of Float, @event.cpu_time
  end

  test 'returns idle_time' do
    get "/users/#{@user.id}/cache"

    assert_instance_of Float, @event.idle_time
  end

  test 'returns allocations' do
    get "/users/#{@user.id}/cache"

    assert_instance_of Integer, @event.allocations
  end

  test 'returns duration' do
    get "/users/#{@user.id}/cache"

    assert_instance_of Float, @event.duration
  end

  test 'calls #to_h' do
    get "/users/#{@user.id}/cache"

    %i[name time end transaction_id cpu_time idle_time allocations duration key].each do |key|
      assert_includes @event.to_h, key
    end
  end

  test 'calls #slice' do
    get "/users/#{@user.id}/cache"

    assert_equal({ name: 'cache_generate.active_support' }, @event.slice(:name))
  end

  test 'returns an instance of CacheGenerate' do
    get "/users/#{@user.id}/cache"

    assert_instance_of RailsBand::ActiveSupport::Event::CacheGenerate, @event
  end

  test 'returns key' do
    get "/users/#{@user.id}/cache"

    assert_equal @user.id, @event.key
  end

  if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
    test 'returns store' do
      get "/users/#{@user.id}/cache"

      assert_equal 'ActiveSupport::Cache::NullStore', @event.store
    end
  else
    test 'raises NoMethodError when accessing store' do
      get "/users/#{@user.id}/cache"
      assert_raises NoMethodError do
        @event.store
      end
    end
  end
end
