# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
require 'rails/test_help'

require 'rails/test_unit/reporter'
Rails::TestUnitReporter.executable = 'bin/test'

require 'minitest/autorun'

# Minitest 6.0 removed Minitest::Mock to a separate gem (minitest-mock).
# We need to provide a compatible mock class for minitest 6.x while still
# supporting minitest 5.x which includes Minitest::Mock.
if Minitest::VERSION >= '6.0.0'
  # Simple mock class to replace Minitest::Mock which was removed in minitest 6.0
  class SimpleMock
    def initialize
      @expected_calls = []
      @actual_calls = []
    end

    def expect(method_name, return_value)
      @expected_calls << method_name
      define_singleton_method(method_name) do
        @actual_calls << method_name
        return_value
      end
      self
    end

    def verify # rubocop:disable Naming/PredicateMethod
      # Check that each expected method was called at least once
      @expected_calls.each do |method_name|
        unless @actual_calls.include?(method_name)
          raise MockExpectationError, "Expected #{method_name.inspect} to be called, but it was not"
        end
      end
      true
    end
  end

  class MockExpectationError < StandardError; end

  # Add assert_mock method to Minitest::Assertions
  module Minitest
    module Assertions
      def assert_mock(mock)
        assert mock.verify, 'Mock verification failed'
      end
    end
  end
else
  # For minitest 5.x, use the built-in Mock
  require 'minitest/mock'
  SimpleMock = Minitest::Mock
end

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = "#{ActiveSupport::TestCase.fixture_path}/files"
  ActiveSupport::TestCase.fixtures :all
end
