# Usage Without `include Paintbrush`

_Paintbrush_ is designed to minimize namespace pollution when used with `include`.

Only one instance method (`#paintbrush`) is defined on the module, so only one method will be reached by your object's method resolver.

_Paintbrush_ also uses a separate namespace for its internals, `PaintbrushSupport`, to minimize adding unwanted constants into an instance's namespace when using `include Paintbrush`.

You may still prefer to not include _Paintbrush_ into your namespace. Simply call `Paintbrush.paintbrush` instead.

```rspec:ansi
subject { Paintbrush.paintbrush { red "I prefer not to #{cyan "include"} Paintbrush" } }

it { is_expected.to include "I prefer not" }
```
