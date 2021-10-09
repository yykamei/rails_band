# frozen_string_literal: true

module RailsBand
  module ActionController
    module Event
      # A wrapper for the event that is passed to `process_action.action_controller`.
      class ProcessAction < BaseEvent
        def controller
          @controller ||= @event.payload.fetch(:controller)
        end

        def action
          @action ||= @event.payload.fetch(:action)
        end

        def params
          @params ||= @event.payload.fetch(:params).except(*INTERNAL_PARAMS)
        end

        def headers
          @headers ||= @event.payload.fetch(:headers)
        end

        def format
          @format ||= @event.payload.fetch(:format)
        end

        def method
          @method ||= @event.payload.fetch(:method)
        end

        def path
          @path ||= @event.payload.fetch(:path).split('?', 2).first
        end

        def status
          @status ||=
            begin
              status = @event.payload[:status]

              if status.nil? && (exception_class_name = @event.payload[:exception]&.first)
                status = ::ActionDispatch::ExceptionWrapper.status_code_for_exception(exception_class_name)
              end
              status
            end
        end

        def view_runtime
          @view_runtime ||= @event.payload.fetch(:view_runtime)
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
          define_method(:request) do
            @request ||= @event.payload[:request]
          end
        end

        if Gem::Version.new(Rails.version) >= Gem::Version.new('6.1')
          define_method(:response) do
            @response ||= @event.payload[:response]
          end
        end

        def db_runtime
          return @db_runtime if defined? @db_runtime

          @db_runtime = @event.payload[:db_runtime]
        end
      end
    end
  end
end
