# frozen_string_literal: true

module Paintbrush
  # Provides methods that are temporarily injected into block context. Each method returns an
  # escaped string including the current stack size with start and end escape codes, allowing the
  # string to be reconstituted afterwards with nested strings restoring the previous color once
  # they have terminated.
  module Colors
    COLOR_CODES = {
      black: '30',
      red: '31',
      green: '32',
      yellow: '33',
      blue: '34',
      purple: '35',
      cyan: '36',
      white: '37',
      default: '39'
    }.freeze

    COLOR_CODES.each do |name, code|
      define_method name do |string|
        if Configuration.colorize?
          ColorElement.new(stack: @__stack, code: code, string: string).to_s
        else
          string
        end
      end
    end

    def method_missing(method_name, *args)
      return super unless method_name.match?(/hex_[a-fA-F0-9]{3,6}/)
      return string unless Configuration.colorize?

      return unless Configuration.colorize?

      ColorElement.new(
        stack: @__stack,
        code: HexColorCode.new(hex_code: method_name).escape_sequence,
        string: args.first
      ).to_s
    end

    def respond_to_missing?(*)
      return super unless method_name.match?(/hex_[a-fA-F0-9]{3,6}/)

      true
    end
  end
end
