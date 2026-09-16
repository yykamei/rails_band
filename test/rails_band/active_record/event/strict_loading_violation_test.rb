# frozen_string_literal: true

require 'test_helper'

if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
  class StrictLoadingViolationTest < ActionDispatch::IntegrationTest
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveRecord::LogSubscriber.consumers = {
        'strict_loading_violation.active_record': ->(event) { @event = event }
      }
      @user = User.create!(name: 'foo', email: 'foo@example.com')
      if ActiveRecord.respond_to?(:action_on_strict_loading_violation)
        @old_ar_config = ActiveRecord.action_on_strict_loading_violation
        ActiveRecord.action_on_strict_loading_violation = :log
      else
        @old_ar_config = ActiveRecord::Base.action_on_strict_loading_violation
        ActiveRecord::Base.action_on_strict_loading_violation = :log
      end

      Note.create!(user: @user, title: 'f')
      Note.create!(user: @user, title: 'g', body: 'G!')
    end

    def event_name
      'strict_loading_violation.active_record'
    end

    def trigger_event
      get "/users/#{@user.id}/notes"
    end

    teardown do
      if ActiveRecord.respond_to?(:action_on_strict_loading_violation)
        ActiveRecord.action_on_strict_loading_violation = @old_ar_config
      else
        ActiveRecord::Base.action_on_strict_loading_violation = @old_ar_config
      end
    end

    test 'calls #to_h' do
      get "/users/#{@user.id}/notes"

      %i[name time end transaction_id cpu_time idle_time allocations duration owner
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
