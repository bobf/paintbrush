# Dynamic Usage

You may have situations where the color you wish to use depends on some state that is unknown until your application is running, and may change between each invocation.

Since _Paintbrush_ colors are regular methods, you can call `public_send` within the block passed to `paintbrush`.


```rspec:ansi
subject do
  paintbrush { blue "The action #{public_send outcome_color, outcome} this time!" }
end

let(:outcome_color) { :green }
let(:outcome) { 'succeeded' }

it { is_expected.to include "\e[32msucceeded\e[0m" }

```

```rspec:ansi
subject do
  paintbrush { blue "The action #{public_send outcome_color, outcome} this time!" }
end

let(:outcome_color) { :red }
let(:outcome) { 'failed' }

it { is_expected.to include "\e[31mfailed\e[0m" }
```
