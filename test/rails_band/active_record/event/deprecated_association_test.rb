# frozen_string_literal: true

require 'test_helper'

if defined?(ActiveRecord.deprecated_associations_options)
  # A test-local model reusing the notes table, so that the shared dummy app
  # stays free of deprecated associations. Defined only where the feature
  # exists because `deprecated:` is an unknown option on older Rails.
  class DeprecatedAssociationNote < ApplicationRecord
    self.table_name = 'notes'
    belongs_to :user, deprecated: true
  end

  class DeprecatedAssociationTest < ActiveSupport::TestCase
    include CommonBaseEventTests

    setup do
      @event = nil
      RailsBand::ActiveRecord::LogSubscriber.consumers = {
        'deprecated_association.active_record': ->(event) { @event = event }
      }
      @original_options = ActiveRecord.deprecated_associations_options
      ActiveRecord.deprecated_associations_options = { mode: :notify, backtrace: false }
    end

    teardown do
      ActiveRecord.deprecated_associations_options = @original_options
    end

    def event_name
      'deprecated_association.active_record'
    end

    def trigger_event
      user = User.create!(name: 'foo', email: 'foo@example.com')
      note = DeprecatedAssociationNote.create!(user: user, title: 'hello')
      note.user
    end

    test 'calls #to_h' do
      trigger_event

      %i[name time end transaction_id cpu_time idle_time allocations duration reflection message location
         backtrace].each do |key|
        assert_includes @event.to_h, key
      end
    end

    test 'calls #slice' do
      trigger_event

      assert_equal({ name: 'deprecated_association.active_record' }, @event.slice(:name))
    end

    test 'returns an instance of DeprecatedAssociation' do
      trigger_event

      assert_instance_of RailsBand::ActiveRecord::Event::DeprecatedAssociation, @event
    end

    test 'returns reflection' do
      trigger_event

      assert_kind_of ActiveRecord::Reflection::AbstractReflection, @event.reflection
    end

    test 'returns message' do
      trigger_event

      assert_instance_of String, @event.message
    end

    test 'returns location' do
      # The location is the first frame cleaned by the Active Record backtrace cleaner,
      # which silences frames from gems and rails_band itself. It may be nil when the
      # invocation happens inside the test framework.
      trigger_event

      assert(@event.location.nil? || @event.location.is_a?(Thread::Backtrace::Location))
    end

    test 'returns nil backtrace when it is not requested' do
      trigger_event

      assert_nil @event.backtrace
    end

    test 'returns backtrace when it is requested' do
      ActiveRecord.deprecated_associations_options = { mode: :notify, backtrace: true }
      trigger_event

      assert_instance_of Array, @event.backtrace
      @event.backtrace.each do |location|
        assert_instance_of Thread::Backtrace::Location, location
      end
    end
  end
end
