# RGB Colors

Using _RGB_ colors gives you the full range of over 16 Million colors to use in your terminal. We won't provide an example for each color but here are a few to give you an idea of how it works.

```rspec:ansi
subject do
  paintbrush do
    "#{hex_f00 'R'}#{hex_ffa500 'A'}#{hex_ff0 'I'}#{hex_080 'N'}" \
    "#{hex_00f 'B'}#{hex_4b0082 'O'}#{hex_ee82ee 'W'}"
  end
end

it 'outputs a rainbow' do
  expect(subject).to eql(
    "\e[38;2;255;0;0mR\e[0m\e[0m\e[38;2;255;165;0mA\e[0m\e[0m" \
    "\e[38;2;255;255;0mI\e[0m\e[0m\e[38;2;0;136;0mN\e[0m\e[0m" \
    "\e[38;2;0;0;255mB\e[0m\e[0m\e[38;2;75;0;130mO\e[0m\e[0m" \
    "\e[38;2;238;130;238mW\e[0m\e[0m"
  )
end
```

Note that both the full hex code and the abbreviated versions are supported, i.e. `hex_ff0` produces the same output as `hex_ffff00`:

```rspec:ansi
subject { paintbrush { hex_ff0 'yellow' } }

it { is_expected.to eql(paintbrush { hex_ffff00 'yellow' }) }
```
