# frozen_string_literal: true

module Paintbrush
  # Provides a configuration interface for Paintbrush features, allows disabling colorization.
  #
  # Usage:
  #
  # ```ruby
  # Paintbrush::Configuration.colorize = false
  # ```
  module Configuration
    @defaults = {
      colorize: true
    }

    @configuration = {}

    class << self
      attr_reader :configuration, :defaults

      def colorize=(val)
        configuration[:colorize] = val
      end

      def colorize?
        configuration.fetch(:colorize, defaults[:colorize])
      end

      def reset
        @configuration = {}
      end

      def with_configuration(**options, &block)
        previous = configuration.dup
        options.compact.each { |key, value| configuration[key] = value unless configuration.key?(key) }
        block.call.tap { @configuration = previous }
      end
    end
  end
end
