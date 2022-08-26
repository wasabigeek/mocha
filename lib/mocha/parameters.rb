module Mocha
  class Parameters
    def initialize(positional_args, keyword_args, block)
      @positional_args = positional_args
      @keyword_args = keyword_args
      @block = block
      @pointer = 0
    end

    def to_a
      # TODO: make it explicit that these should be a new array
      @positional_args + (@keyword_args.empty? ? [] : [@keyword_args])
    end

    def shift
      current_position = @pointer
      @pointer += 1
      return positional_args[current_position] if current_position < (positional_args.size)
      return keyword_args unless keyword_args.empty?

      nil
    end

    class << self
      def from_ruby2_keywords(marked_args, block)
        keyword_args = if marked_args.last.is_a?(Hash) && Hash.ruby2_keywords_hash?(marked_args)
          marked_args.pop
        else
          {}
        end

        new(marked_args, keyword_args, block)
      end
    end
  end
end
