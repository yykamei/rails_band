# frozen_string_literal: true

module RailsBand
  # RailsBand::Configuration is responsible for storing user-specified configuration.
  class Configuration
    # Consumer is a wrapper of ActiveSupport::HashWithIndifferentAccess, which validates the value on #[]=.
    class Consumer < ActiveSupport::HashWithIndifferentAccess
      def []=(key, value)
        unless value.respond_to?(:call)
          raise ArgumentError, "The value for `#{key.inspect}` must have #call: the passed one is `#{value.inspect}`"
        end

        super(key, value)
      end
    end

    # @return [Consumer]
    attr_reader :consumer

    def initialize
      @consumer = Consumer.new
    end

    # @param value [Hash, #call]
    #   Consumer(s) to be called when instrumentation APIs are dispatched. If you pass a single value that has `#call`
    #   method, the value is going to be always called for any instrumentation API events. You can also specify
    #   consumers, assigning a Hash, the keys of which are instrumentation API event names. When the value is a Hash,
    #   you are able to set a key, named `:default`, which is called for the rest of instrumentation API events
    #   you don't assign.
    #
    #   Instrumentation API event names can be full event names or just namespaces, such as `:action_controller`.
    #
    # @example
    #   config = RailsBand::Configuration.new
    #   config.consumer = ->(e) { Rails.logger.info(e) }
    #   config.consumer = {
    #     default: ->(e) { Rails.logger.info(e) }
    #     action_controller: ->(e) { Rails.logger.info("ActionController! #{e}") }
    #     'render_template.action_view': ->(e) { Rails.logger.debug("RenderTemplate! #{e}") }
    #   }
    #
    # @see https://guides.rubyonrails.org/active_support_instrumentation.html
    def consumer=(value)
      @consumer =
        case value
        when Hash
          value.each_with_object(Consumer.new) do |(k, v), c|
            c[k] = v
          end
        else
          Consumer.new.tap { |c| c[:all] = value }
        end
    end
  end
end
