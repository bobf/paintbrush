# frozen_string_literal: true

require_relative 'paintbrush_support/version'
require_relative 'paintbrush_support/configuration'
require_relative 'paintbrush_support/escapes'
require_relative 'paintbrush_support/colors'
require_relative 'paintbrush_support/colorized_string'
require_relative 'paintbrush_support/color_element'
require_relative 'paintbrush_support/hex_color_code'
require_relative 'paintbrush_support/bounded_color_element'
require_relative 'paintbrush_support/element_tree'

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
    PaintbrushSupport::ColorizedString.new(colorize: colorize, &block).colorized
  end

  def self.configure
    yield PaintbrushSupport::Configuration
  end

  def self.with_configuration(**options, &block)
    PaintbrushSupport::Configuration.with_configuration(**options, &block)
  end

  def paintbrush(colorize: nil, &block)
    Paintbrush.paintbrush(colorize: colorize, &block)
  end
end
