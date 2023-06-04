# Configuration

_Paintbrush_ provides one simple configuration option, allowing you to enable or disable colorization either globally, per-invocation, or within a block.

Note that global configuration overrides block configuration, and block configuration overrides per-invocation configuration. i.e. any method-level configurations have no impact if a global configuration is set.

## Global Configuration

Disable colorization globally by adding the following code somewhere near the beginning of your application's start-up process (e.g. in _Rails_, an initializer is a good place to put this):

```ruby
# config/initializers/paintbrush.rb

Paintbrush.configure do |config|
  config.colorize = false if Rails.env.production?
end
```

All calls to `#paintbrush` will now return a regular, uncolorized string.

## Block Configuration

_Paintbrush_ can be configured for the duration of a block by calling `Paintbrush.with_configuration`. e.g. you may want to disable colorization in your tests to make testing output a bit easier. If you're using _RSpec_ you can add the following to `spec/spec_helper.rb`:

```ruby
# spec/spec_helper.rb

RSpec.configure do |config|
  config.around { |example| Paintbrush.with_configuration(colorize: false) { example.call } }
end
```

```rspec:ansi
subject do
  Paintbrush.with_configuration(colorize: false) { paintbrush { red 'An uncolorized string' } }
end

it { is_expected.to eql 'An uncolorized string' }
```

## Method Invocation Configuration

Pass `colorize: false` to `paintbrush` directly to disable colorization for a single call. This is especially useful when generating a message in two or more contexts. For example, you may want to render the same message to a development log as well as returning that message in a web response, one with colorization and one without:

```rspec:ansi
def my_message(colorize: true)
  paintbrush(colorize: colorize) { cyan "A log message with colors in some contexts." }
end

subject { my_message(colorize: true) }

it { is_expected.to include "\e[36m" }
```

```rspec:ansi
def my_message(colorize: true)
  paintbrush(colorize: colorize) { cyan "A log message with colors in some contexts." }
end

subject { my_message(colorize: false) }

it { is_expected.not_to include "\e[36m" }
```
