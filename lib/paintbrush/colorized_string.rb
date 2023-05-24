# frozen_string_literal: true

module Paintbrush
  # Core string colorization, provides various methods for colorizing a string, uses escape
  # sequences to store references to start and end of each coloring method to allow nested
  # colorizing with string interpolation within each individual call to `paintbrush`.
  class ColorizedString
    def initialize(&block)
      @block = block
      @codes = []
    end

    # Returns a colorized string by injecting escape codes into the various calls to each color
    # method in the provided block, rebuilds the string and returns the value with regular ANSI
    # color codes ready to be output to a console.
    def colorized
      colorized_string
    end

    private

    attr_reader :block, :codes

    def colorized_string
      codes.each.with_index.reduce(escaped_output) do |string, (code, index)|
        restored_color_code = index + 1 == codes.size ? '0' : codes[index + 1]
        subbed_string(string, index, code, restored_color_code)
      end
    end

    def subbed_string(string, index, code, restored_color_code)
      string
        .sub("#{Colors::ESCAPE_START_OPEN}#{index}#{Colors::ESCAPE_START_CLOSE}", "\e[#{code}m")
        .sub("#{Colors::ESCAPE_END_OPEN}#{index}#{Colors::ESCAPE_END_CLOSE}", "\e[0m\e[#{restored_color_code}m")
    end

    def escaped_output
      context.instance_eval(&block)
    end

    def context
      eval('self', block.binding, __FILE__, __LINE__).dup.tap do |context|
        context.send(:include, Paintbrush::Colors) if context.respond_to?(:include)
        context.send(:extend, Paintbrush::Colors) if context.respond_to?(:extend)
        context.send(:instance_variable_set, :@__codes, codes)
      end
    end
  end
end
