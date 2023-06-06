# How It Works

_Paintbrush_ can be broken down into four components:

1. Context manipulation.
1. String encoding.
1. Color code tree construction.
1. Re-encoding into a colorized string.

## Context Manipulation

_Paintbrush_ cares about namespace pollution. It avoids adding methods and constants into a namespace where possible, and it does not overload or extend any other objects. _Paintbrush's_ methods are only available within the block passed to the `#paintbrush` method.

To achieve this, _Paintbrush_ duplicates the binding of the current block (i.e. the namespace that invoked `#paintbrush`), injects a module `PaintbrushSupport::Colors` (which provides the color methods like `#cyan`) into the duplicated context's `self`, and also adds a `@__stack` instance variable which is unique to each invocation of `#paintbrush`.

Each call to `#green`, `#blue`, etc. adds a new `PaintbrushSupport::ColorElement` to the stack, which stores the name of the invoked color method, the string it received, and its index in the current stack.

The `ColorElement` object is then returned so _Ruby_ can interpolate it, calling `ColorElement#to_s` which returns an encoded string.

## String Encoding

Each encoded string includes the following:

* An escape code indicating the beginning of the string.
* The index of the item in the current stack.
* The original string received to the color method.
* An escape code indicating the end of the string.

The index is encoded to both the start end end boundaries of the substring, which allows nested colorized strings. The structure is similar to open and close tags in _XML_, with each tag having a unique identifier attribute.

The raw encoded string looks like this (slightly formatted to allow text wrapping):

```rspec
subject do
  PaintbrushSupport::ColorizedString.new(colorize: true) { red "red #{green "green #{blue "blue"}"}" }
                                    .send(:escaped_output)
                                    .gsub("CLOSE", "CLOSE ")
end

it { is_expected.to include "green" }
```
This encoded string could be represented in _XML_, for example:

```xml
<color code="red" id="2">
  red
  <color code="green" id="1">
    green
    <color code="blue" id="0">
      blue
    </color>
  </color>
</color>
```
However, since the leaf nodes are generated first, and each leaf node does not know where it will appear in the final string, the tree data is built back-to-front and the tree needs to be constructed from the encoded string. Leaves can't attach themselves to parents that don't exist yet, but the resulting string contains information for each node's start/end points and its index in the stack.

## Color Code Tree Construction

Once the encoded string has been generated, a tree structure is built by identifying the start and end points of each substring, finding the largest non-overlapping ranges as 1st-generation children, and then repeating the same algorithm using each parent's boundaries to identify direct descendants, until no direct descendants exist (i.e. we have found a leaf node).

## Re-encoding into a colorized string

Once the final string has been decoded into a tree structure, each leaf node can inspect its parent to identify which color code should be restored. e.g. if a leaf node has color "yellow" and its parent has color "green", the resulting substring will start with the escape code for yellow, then the string's original value, then the escape code for green.

This process is repeated recursively back up the tree until the root is found, at which point the color is reset to the terminal's default.

## Summary

_Paintbrush_ provides method resolution by modifying a duplicate of the current context, then creates a series of encoded strings with unlimited (within _Ruby's_ own stack size limit) nested string interpolation. The intermediary encoded string is parsed into a tree when the result is returned to the main `#paintbrush` method. The tree is then traversed from the leaf nodes to the root, re-encoding into a string of _ANSI_ color sequences that restore each node's parent color, providing developers with (hopefully) a more pleasant way of building colorized terminal output than they are used to.

Here's the result:

```rspec:ansi
subject do
  paintbrush do
    "nesting with #{blue 'foo'} #{green "bar #{cyan "baz"} with #{cyan 'qux'} and quux"} and #{red "corge"}"
  end
end

it { is_expected.to include 'baz' }
```

Try some of the [alternatives](alternatives.html) to compare equivalent functionality across different implementations.

Raise an [issue](https://github.com/bobf/paintbrush/issues) if you want to suggest a feature or report a bug.
