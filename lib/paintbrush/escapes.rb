# frozen_string_literal: true

module Paintbrush
  # Provides an authority on escape code generation. Provides `.close` and `.open`, both of which
  # receive an index (i.e. the current size of the stack). Used for escape code insertion and comparison.
  module Escapes
    def self.open(index)
      "\e[3;15;17]START_OPEN:#{index}:\e[3;15;17]START_CLOSE"
    end

    def self.close(index)
      "\e[17;15;3]END_OPEN:#{index}:\e[17;15;3]END_CLOSE"
    end
  end
end
