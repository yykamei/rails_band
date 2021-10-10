# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
  class StrictLoadingViolationTest < ActionDispatch::IntegrationTest
    setup do
      @event = nil
      RailsBand::ActiveRecord::LogSubscriber.consumers = {
        'strict_loading_violation.active_record': ->(event) { @event = event }
      }
      @user = User.create!(name: 'foo', email: 'foo@example.com')
      @old_ar_config = ActiveRecord::Base.action_on_strict_loading_violation
      ActiveRecord::Base.action_on_strict_loading_violation = :log

      Note.create!(user: @user, title: 'f')
      Note.create!(user: @user, title: 'g', body: 'G!')
    end

    teardown do
      ActiveRecord::Base.action_on_strict_loading_violation = @old_ar_config
    end

    test 'returns name' do
      get "/users/#{@user.id}/notes"
      assert_equal 'strict_loading_violation.active_record', @event.name
    end

    test 'returns time' do
      get "/users/#{@user.id}/notes"
      assert_instance_of Float, @event.time
    end

    test 'returns end' do
      get "/users/#{@user.id}/notes"
      assert_instance_of Float, @event.end
    end

    test 'returns transaction_id' do
      get "/users/#{@user.id}/notes"
      assert_instance_of String, @event.transaction_id
    end

    test 'returns children' do
      get "/users/#{@user.id}/notes"
      assert_instance_of Array, @event.children
    end

    test 'returns cpu_time' do
      get "/users/#{@user.id}/notes"
      assert_instance_of Float, @event.cpu_time
    end

    test 'returns idle_time' do
      get "/users/#{@user.id}/notes"
      assert_instance_of Float, @event.idle_time
    end

    test 'returns allocations' do
      get "/users/#{@user.id}/notes"
      assert_instance_of Integer, @event.allocations
    end

    test 'returns duration' do
      get "/users/#{@user.id}/notes"
      assert_instance_of Float, @event.duration
    end

    test 'calls #to_h' do
      get "/users/#{@user.id}/notes"
      %i[name time end transaction_id children cpu_time idle_time allocations duration owner
         reflection].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      get "/users/#{@user.id}/notes"
      assert_equal({ name: 'strict_loading_violation.active_record' }, @event.slice(:name))
    end

    test 'returns an instance of StrictLoadingViolation' do
      get "/users/#{@user.id}/notes"
      assert_instance_of RailsBand::ActiveRecord::Event::StrictLoadingViolation, @event
    end

    test 'returns owner' do
      get "/users/#{@user.id}/notes"
      assert_equal User, @event.owner
    end

    test 'returns reflection' do
      get "/users/#{@user.id}/notes"
      assert_instance_of ActiveRecord::Reflection::HasManyReflection, @event.reflection
      assert_equal Note, @event.reflection.klass
      assert_equal :notes, @event.reflection.name
    end
  end
end
