# frozen_string_literal: true

module Paintbrush
  # Provides methods that are temporarily injected into block context. Each method returns an
  # escaped string including the current stack size with start and end escape codes, allowing the
  # string to be reconstituted afterwards with nested strings restoring the previous color once
  # they have terminated.
  module Colors
    ESCAPE_START_OPEN = "\e[3;15;17]OPEN:"
    ESCAPE_START_CLOSE = "\e[3;15;17]CLOSE:"
    ESCAPE_END_OPEN = "\e[17;15;3]OPEN:"
    ESCAPE_END_CLOSE = "\e[17;15;3]CLOSE:"

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
        @__codes.push(code)
        "#{ESCAPE_START_OPEN}#{@__codes.size - 1}#{ESCAPE_START_CLOSE}" \
          "#{string}" \
          "#{ESCAPE_END_OPEN}#{@__codes.size - 1}#{ESCAPE_END_CLOSE}"
      end
    end
  end
end
