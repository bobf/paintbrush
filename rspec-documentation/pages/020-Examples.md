# Examples

See the individual example pages for usage patterns. Examples are provided to cover basic usage as well as more complex nested colors with multiple color variants. Remember to `include Paintbrush` anywhere you wish to use it.

Experiment with _Paintbrush_ from a terminal to get a feel for it:

```irb
irb(main):001:0> require 'paintbrush'
=> true
irb(main):002:0> include Paintbrush
=> Object
irb(main):003:0> puts(paintbrush { green "hello #{cyan 'new'} #{blue 'Paintbrush'} user" })
hello new Paintbrush user
```

```rspec:ansi
subject { paintbrush { green "hello #{cyan 'new'} #{blue 'Paintbrush'} user" } }

it { is_expected.to include 'Paintbrush' }
```
