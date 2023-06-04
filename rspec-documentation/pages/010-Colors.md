# Colors

_Paintbrush_ defines the following colors. Each color is avaiable as a method call inside a block passed to the `paintbrush` method.

## Basic Colors

* `black`
* `red`
* `green`
* `yellow`
* `blue`
* `purple`
* `cyan`
* `white`
* `default`

```rspec:ansi
subject { paintbrush { purple 'a purple string' } }

it { is_expected.to include "\e[35ma purple string" }
```

## Bright Colors

Add the `_b` suffix to get the "bright" version of the relevant color.

* `black_b`
* `red_b`
* `green_b`
* `yellow_b`
* `blue_b`
* `purple_b`
* `cyan_b`
* `white_b`

```rspec:ansi
subject { paintbrush { purple_b 'a bright purple string' } }

it { is_expected.to include "\e[95ma bright purple string" }
```

## RGB Colors

As well as the colors listed below, any RGB hex color code (e.g. `ff00ff`) is available as a method prefixed with `hex_`, e.g. use `hex_ff00ff` for magenta.

The shorthand versions `#hex_f0f` are also provided, i.e. `#hex_f0f` is equivalent to `#hex_ff00ff`.

```rspec:ansi
subject { paintbrush { hex_f0f 'a magenta string' } }

it { is_expected.to include "\e[38;2;255;0;255ma magenta string" }
```
