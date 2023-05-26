# frozen_string_literal: true

module Paintbrush
  # Core string colorization, provides various methods for colorizing a string, uses escape
  # sequences to store references to start and end of each coloring method to allow nested
  # colorizing with string interpolation within each individual call to `paintbrush`.
  class ColorizedString
    def initialize(&block)
      @block = block
      @stack = []
    end

    # Returns a colorized string by injecting escape codes into the various calls to each color
    # method in the provided block, rebuilds the string and returns the value with regular ANSI
    # color codes ready to be output to a console.
    def colorized
      colorized_string
    end

    private

    attr_reader :block, :stack

    def colorized_string(string: escaped_output, tree: element_tree)
      tree[:children].reduce(string) do |output, child|
        subbed = subbed_string(output, child[:node], tree[:node])
        next subbed if child[:children].empty?

        colorized_string(string: subbed, tree: child)
      end
    end

    def bounded_color_elements
      @bounded_color_elements ||= stack.map do |color_element|
        BoundedColorElement.new(color_element: color_element, escaped_output: escaped_output)
      end
    end

    def element_tree
      @element_tree ||= ElementTree.new(bounded_color_elements: bounded_color_elements).tree
    end

    def subbed_string(string, color_element, parent_color_element)
      restored_color_code = parent_color_element.nil? ? '0' : parent_color_element.code
      string
        .sub(Escapes.open(color_element.index).to_s, "\e[#{color_element.code}m")
        .sub(Escapes.close(color_element.index).to_s, "\e[0m\e[#{restored_color_code}m")
    end

    def escaped_output
      @escaped_output ||= context.instance_eval(&block)
    end

    def context
      eval('self', block.binding, __FILE__, __LINE__).dup.tap do |context|
        context.send(:include, Paintbrush::Colors) if context.respond_to?(:include)
        context.send(:extend, Paintbrush::Colors) if context.respond_to?(:extend)
        context.send(:instance_variable_set, :@__stack, stack)
      end
    end
  end
end
