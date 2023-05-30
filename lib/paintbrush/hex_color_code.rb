# frozen_string_literal: true

module Paintbrush
  # Translates a string in format `hex_ff00ff` or `hex_f0f` into an RGB escape code sequence.
  # Allows calling e.g.:
  #
  # paintbrush { hex_ff0ff 'hello in magenta' }
  #
  class HexColorCode
    def initialize(hex_code:)
      @hex_code = hex_code
    end

    def escape_sequence
      (%w[38 2] + encoded_pairs).join(';')
    end

    private

    attr_reader :hex_code

    def encoded_pairs
      pairs.map { |pair| pair.to_i(16).to_s }
    end

    def pairs
      normalized_hex_string.chars.each_slice(2).map(&:join)
    end

    def hex_string
      @hex_string ||= hex_code.to_s.partition('hex_').last
    end

    def normalized_hex_string
      return hex_string if hex_string.size == 6

      hex_string.chars.map { |char| "#{char}#{char}" }.join
    end
  end
end
