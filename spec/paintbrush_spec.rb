# frozen_string_literal: true

RSpec.describe Paintbrush do
  include described_class

  it 'has a version number' do
    expect(Paintbrush::VERSION).not_to be_nil
  end

  it 'renders a colorized string' do
    output = paintbrush { white "You used #{green 'four'} #{blue "(#{cyan '4'})"} #{yellow 'colors'} today!" }
    puts output
    expect(output).to eql "\e[37mYou used \e[32mfour\e[0m\e[36m " \
                          "\e[34m(\e[36m4\e[0m\e[34m)\e[0m\e[33m \e[33mcolors\e[0m\e[37m today!\e[0m\e[0m"
  end

  it 'does not pollute the current namespace' do
    paintbrush { green 'hello' }
    expect { green }.to raise_error NameError
  end
end
