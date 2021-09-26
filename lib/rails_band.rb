# frozen_string_literal: true

require 'rails_band/version'
require 'rails_band/railtie'

# Rails::Band unsubscribes all default LogSubscribers from Rails Instrumentation API,
# and it subscribes our own custom LogSubscribers to make it easy to access Rails Instrumentation API.
module RailsBand
  # Your code goes here...
end
