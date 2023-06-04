# frozen_string_literal: true

RSpec::Documentation.configure do |config|
  config.context do
    require 'paintbrush'
    include Paintbrush
  end
end
