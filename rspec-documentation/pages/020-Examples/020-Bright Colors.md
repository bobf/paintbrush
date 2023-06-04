# Bright Colors

Use the `_b` suffix for a color name to make a **bright** color. See [Colors](../colors.html) for more details.

```rspec:ansi
subject { paintbrush { blue_b "bright blue" } }

it { is_expected.to include 'bright blue' }
```

```rspec:ansi
subject { paintbrush { "#{blue "some blue text"} #{blue_b "and some bright blue text"}" } }

it { is_expected.to include 'bright blue' }
```
