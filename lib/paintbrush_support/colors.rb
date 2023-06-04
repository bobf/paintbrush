# frozen_string_literal: true

module PaintbrushSupport
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
      default: '39',
      black_b: '90',
      red_b: '91',
      green_b: '92',
      yellow_b: '93',
      blue_b: '94',
      purple_b: '95',
      cyan_b: '96',
      white_b: '97'
    }.freeze

    HEX_CODE_REGEXP = /(?:hex_[a-fA-F0-9]{3}){1,2}/.freeze

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
      return super unless method_name.match?(HEX_CODE_REGEXP)
      return string unless Configuration.colorize?

      return unless Configuration.colorize?

      ColorElement.new(
        stack: @__stack,
        code: HexColorCode.new(hex_code: method_name).escape_sequence,
        string: args.first
      ).to_s
    end

    def respond_to_missing?(*)
      return super unless method_name.match?(HEX_CODE_REGEXP)

      true
    end
  end
end
