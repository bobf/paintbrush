# frozen_string_literal: true

module PaintbrushSupport
  # Wraps a Paintbrush::ColorElement instance and maps its start and end boundaries within a
  # compiled escaped string by matching specific unique (indexed) escape codes. Provides
  # `#surround?` for detecting if another element exists within the current element's boundaries.
  class BoundedColorElement
    def initialize(color_element:, escaped_output:)
      @color_element = color_element
      @escaped_output = escaped_output
    end

    def surround?(element)
      return false if element == self
      return false unless element.open_index.between?(open_index, close_index)
      return false unless element.close_index.between?(open_index, close_index)

      true
    end

    def inspect
      "<#{self.class} boundaries=#{boundaries}>"
    end

    def index
      color_element.index
    end

    def code
      color_element.code
    end

    def boundaries
      @boundaries ||= [open_index, close_index]
    end

    def open_index
      @open_index ||= escaped_output.index(Escapes.open(index))
    end

    def close_index
      escaped_output.index(Escapes.close(index))
    end

    private

    attr_reader :escaped_output, :color_element
  end
end
