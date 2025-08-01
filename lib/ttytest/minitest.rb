# frozen_string_literal: true

require 'ttytest/assertions'

module TTYtest
  # Wrappers for ttytest::assertions for use with Minitest
  module Minitest
    def wrap_assertions_for_minitest(*method_names)
      method_names.each do |name|
        original = instance_method(name)

        define_method(name) do |*args, **kwargs, &block|
          original.bind(self).call(*args, **kwargs, &block)
        rescue MatchError => e
          raise Minitest::Assertion, e.message
        end
      end
    end

    # Usage:
    # wrap_assertions_for_minitest :assert_row, :assert_row_contains
    # todo: list methods matching assert_* with reflection

    # MINITEST_ASSERTION_METHODS = public_instance_methods
  end
end
