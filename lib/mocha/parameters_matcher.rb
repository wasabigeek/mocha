require 'mocha/inspect'
require 'mocha/parameter_matchers'
require 'mocha/parameter_matchers/last_positional_hash'

module Mocha
  class ParametersMatcher
    def initialize(expected_parameters = [ParameterMatchers::AnyParameters.new], &matching_block)
      @expected_parameters = expected_parameters
      @matching_block = matching_block
    end

    def match?(actual_parameters = Parameters.new)
      if @matching_block
        # ideally also separate positional and keyword args, but would be a breaking API change
        @matching_block.call(*actual_parameters.to_a)
      else
        parameters_match?(actual_parameters)
      end
    end

    def mocha_inspect
      signature = matchers.mocha_inspect
      signature = signature.gsub(/^\[|\]$/, '')
      signature = signature.gsub(/^\{|\}$/, '') if matchers.length == 1
      "(#{signature})"
    end

    private

    def parameters_match?(actual_parameters)
      # TODO: match keyword args separately
      matchers.all? { |matcher| matcher.matches?(actual_parameters) } && actual_parameters.empty?
    end

    def matchers
      @expected_parameters.map(&:to_matcher)
    end
  end
end
