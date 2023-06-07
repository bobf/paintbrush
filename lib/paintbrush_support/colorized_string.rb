# frozen_string_literal: true

module PaintbrushSupport
  # Core string colorization, provides various methods for colorizing a string, uses escape
  # sequences to store references to start and end of each coloring method to allow nested
  # colorizing with string interpolation within each individual call to `paintbrush`.
  class ColorizedString
    def initialize(colorize:, &block)
      @colorize = colorize
      @block = block
      @stack = []
    end

    # Returns a colorized string by injecting escape codes into the various calls to each color
    # method in the provided block, rebuilds the string and returns the value with regular ANSI
    # color codes ready to be output to a console.
    def colorized
      Configuration.with_configuration(colorize: @colorize) do
        colorized_string
      end
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
      @bounded_color_elements ||= colors.stack.map do |color_element|
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
      @escaped_output ||= context(colors).instance_eval(&block)
    end

    def colors
      @colors ||= Colors.new
    end

    def context(colors = nil)
      return @context if defined?(@context)

      @context = eval('self', block.binding, __FILE__, __LINE__).tap do |context|
        context.define_singleton_method(:method_missing) { |method_name, *args| colors.send(method_name, *args) }
      end
    end
  end
end
