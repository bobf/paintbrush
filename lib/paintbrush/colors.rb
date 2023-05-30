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
  end
end
