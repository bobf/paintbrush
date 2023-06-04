# Paintbrush

Simple and concise string colorization for _Ruby_ without overloading `String` methods or requiring verbose class/method invocation.

_Paintbrush_ has zero dependencies and does not pollute any namespaces or objects outside of the `#paintbrush` method wherever you include the `Paintbrush` module.

Nesting is supported, allowing you to use multiple colors within the same string. The previous color is automatically restored.

```ruby
include Paintbrush
puts paintbrush { purple "You used #{green 'four'} #{blue "(#{cyan '4'})"} #{yellow 'colors'} today!" }
```
![example](doc/example.png "Example")

## Installation

Add _Paintbrush_ to your `Gemfile`:

```ruby
gem 'paintbrush'
```

Build your bundle:

```ruby
bundle install
```

## Documentation

See the [Official Documentation](https://docs.bob.frl/paintbrush) for examples and configuration options.

## License

_Paintbrush_ is released under the [MIT License](https://opensource.org/license/mit/).
