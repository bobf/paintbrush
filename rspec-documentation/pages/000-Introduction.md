# Introduction

Simple and concise string colorization for _Ruby_ without overloading `String` methods or requiring verbose class/method invocation.

_Paintbrush_ has zero dependencies and does not pollute any namespaces or objects outside of the `#paintbrush` method wherever you include the `Paintbrush` module.

Nesting is supported, allowing you to use multiple colors within the same string. The previous color is automatically restored.

## Quick Example

```rspec:ansi
require 'paintbrush'

include Paintbrush

subject { paintbrush { purple "You used #{green 'four'} #{blue "(#{cyan '4'})"} #{yellow 'colors'} today!" } }

it 'outputs simple colorized strings' do
  expect(subject).to eql "\e[35mYou used \e[32mfour\e[0m\e[35m " \
                         "\e[34m(\e[36m4\e[0m\e[34m)\e[0m\e[35m " \
                         "\e[33mcolors\e[0m\e[35m today!\e[0m\e[0m"
end
```
