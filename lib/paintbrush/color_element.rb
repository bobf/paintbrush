# frozen_string_literal: true

module Paintbrush
  # Provides a substring enclosed in unique escape codes for later colorization when the full
  # string has been created and all interpolation is completed. Adds itself to a provided stack
  # of ColorElement objects on initialization.
  class ColorElement
    attr_reader :stack, :code, :string, :index
    attr_accessor :open_index, :close_index

    def initialize(stack:, code:, string:)
      @stack = stack
      @code = code
      @string = string
      @index = stack.size
      stack << self
    end

    def to_s
      "#{Escapes.open(index)}#{string}#{Escapes.close(index)}"
    end

    def inspect
      "<#{self.class.name} index=#{index} code=#{code}>"
    end
  end
end
