# frozen_string_literal: true

module RailsBand
  module ActiveRecord
    module Event
      # ActionView::RenderCollection is a wrapper for the event that is passed to `render_collection.action_view`.
      class Sql < BaseEvent
        def sql
          @sql ||= @event.payload.fetch(:sql)
        end

        # @note This method is renamed in order to avoid conflicts with BaseEvent#name.
        def sql_name
          @sql_name ||= @event.payload.fetch(:name)
        end

        def binds
          @binds ||= @event.payload.fetch(:binds)
        end

        def type_casted_binds
          @type_casted_binds ||= @event.payload.fetch(:type_casted_binds)
        end

        def connection
          @connection ||= @event.payload.fetch(:connection)
        end

        def statement_name
          return @statement_name if defined? @statement_name

          @statement_name = @event.payload[:statement_name]
        end

        def async
          return @async if defined? @async

          @async = @event.payload[:async]
        end

        def cached
          return @cached if defined? @cached

          @cached = @event.payload[:cached]
        end
      end
    end
  end
end
