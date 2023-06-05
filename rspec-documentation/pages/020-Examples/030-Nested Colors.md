# Nested Colors

_Paintbrush_ supports unlimited levels of nesting, allowing you to use one color inside another color and have the text revert back to its previous color. This lets you create complex colorized strings without having to revert back manually.

```rspec:ansi
subject do
  paintbrush do
    green "green, #{blue "blue, #{cyan "cyan #{yellow "and yellow"}, back to cyan"}, back to blue"}, and back to green"
  end
end

it { is_expected.to include "and yellow" }
```
