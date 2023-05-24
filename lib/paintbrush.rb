# frozen_string_literal: true

require_relative 'paintbrush/version'
require_relative 'paintbrush/colors'
require_relative 'paintbrush/colorized_string'

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
  class Error < StandardError; end

  def paintbrush(&block)
    ColorizedString.new(&block).colorized
  end
end
