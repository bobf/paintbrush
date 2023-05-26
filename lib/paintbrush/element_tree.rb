# frozen_string_literal: true

module Paintbrush
  # A tree of BoundedColorElement objects. Used to build a full tree of colorized substrings in
  # order to allow discovery of parent substrings and use their color code to restore to when the
  # substring is terminated. Allows deeply-nested colorized strings.
  class ElementTree
    attr_reader :tree

    def initialize(bounded_color_elements:)
      @bounded_color_elements = bounded_color_elements
      @tree = { node: nil, children: [] }
      build_tree(boundary_end: bounded_color_elements.map(&:close_index).max)
    end

    def build_tree(boundary_end:, root: @tree, elements: bounded_color_elements, boundary_start: 0)
      root_nodes, non_root_nodes = partitioned_elements(elements, boundary_start, boundary_end)

      root_nodes.each do |node|
        root[:children] << child_node(node)
        build_tree(
          root: root[:children].last,
          elements: non_root_nodes,
          boundary_start: node.open_index,
          boundary_end: node.close_index
        )
      end
    end

    private

    attr_reader :bounded_color_elements

    def child_node(node)
      { node: node, children: [] }
    end

    def partitioned_elements(elements, boundary_start, boundary_end)
      elements.partition do |element|
        next false if elements.any? { |child| child.surround?(element) }

        element.boundaries.all? { |index| index.between?(boundary_start, boundary_end) }
      end
    end
  end
end
