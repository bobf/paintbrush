# Basic Usage

The most basic usage of _Paintbrush_ is with no colorization at all:

```rspec:ansi
subject { paintbrush { 'an uncolorized string' } }

it { is_expected.to eql 'an uncolorized string' }
```

As you can see, a duplicate of the original string is returned intact with no modifications.

The second-most basic usage of _Paintbrush_ is with a single color:

```rspec:ansi
subject { paintbrush { green 'some green text' } }

it { is_expected.to include 'some green text' }
```
