# frozen_string_literal: true

require_relative 'paintbrush/version'
require_relative 'paintbrush/configuration'
require_relative 'paintbrush/escapes'
require_relative 'paintbrush/colors'
require_relative 'paintbrush/colorized_string'
require_relative 'paintbrush/color_element'
require_relative 'paintbrush/bounded_color_element'
require_relative 'paintbrush/element_tree'

# Colorizes a string, provides `#paintbrush`. When included/extended in a class, call
# `#paintbrush` and pass a block to use the provided dynamically defined methods, e.g.:
#
# ```ruby
# class Foo
#   include Paintbrush
#
#   def bar
#     puts paintbrush { cyan("hello #{green("there")}) }
#   end
# ```
module Paintbrush
  def self.paintbrush(colorize: nil, &block)
    ColorizedString.new(colorize: colorize, &block).colorized
  end

  def paintbrush(colorize: nil, &block)
    Paintbrush.paintbrush(colorize: colorize, &block)
  end
end
