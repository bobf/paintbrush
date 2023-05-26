# frozen_string_literal: true

RSpec.describe Paintbrush do
  include described_class

  it 'has a version number' do
    expect(Paintbrush::VERSION).not_to be_nil
  end

  it 'renders a colorized string' do
    output = paintbrush { purple "You used #{green 'four'} #{blue "(#{cyan '4'})"} #{yellow 'colors'} today!" }
    expect(output).to eql "\e[35mYou used \e[32mfour\e[0m\e[35m \e[34m(\e[36m4\e[0m\e[34m)\e[0m\e[35m " \
                          "\e[33mcolors\e[0m\e[35m today!\e[0m\e[0m"
  end

  it 'does not pollute the current namespace' do
    paintbrush { green 'hello' }
    expect { green }.to raise_error NameError
  end

  it 'renders with complex nesting' do
    output = paintbrush do
      "#{blue 'foo'} #{green "bar #{cyan %w[foo bar baz].join(', ')} with #{cyan 'qux'} and quux"} and corge"
    end
    expect(output).to eql "\e[34mfoo\e[0m\e[0m \e[32mbar \e[36mfoo, bar, baz\e[0m\e[32m with " \
                          "\e[36mqux\e[0m\e[32m and quux\e[0m\e[0m and corge"
  end
end
