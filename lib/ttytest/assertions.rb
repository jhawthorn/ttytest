# frozen_string_literal: true

require 'minitest/assertions'

module TTYtest
  module Minitest
    # Define assertions that can be used in a minitest context.
    # They are just like matchers, but will count towards stats when running tests with minitest.
    module Assertions
      # Asserts the contents of a single row match the value expected
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value of the row. Any trailing whitespace is ignored
      def assert_row(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        assert actual == expected,
               "expected row #{row_number} to be #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row don't match the value expected
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value of the row. Any trailing whitespace is ignored
      def refute_row(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        refute actual == expected,
               "expected row #{row_number} to not be #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row contains the expected string at a specific position
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [Integer] column_start the column position to start comparing expected against
      # @param [Integer] columns_end the column position to end comparing expected against
      # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
      def assert_row_at(row_number, column_start, column_end, expected)
        expected = expected.rstrip
        actual = row(row_number)
        column_end += 1 if column_end.positive?
        assert actual[column_start, column_end].eql?(expected),
               "expected row #{row_number} to contain #{expected[column_start,
                                                                 column_end]} at #{column_start}-#{column_end} and got #{actual[column_start,
                                                                                                                                column_end]}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row do not contain the expected string at a specific position
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [Integer] column_start the column position to start comparing expected against
      # @param [Integer] columns_end the column position to end comparing expected against
      # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
      def refute_row_at(row_number, column_start, column_end, expected)
        expected = expected.rstrip
        actual = row(row_number)
        column_end += 1 if column_end.positive?
        refute actual[column_start, column_end].eql?(expected),
               "expected row #{row_number} to contain #{expected[column_start,
                                                                 column_end]} at #{column_start}-#{column_end} and got #{actual[column_start,
                                                                                                                                column_end]}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row contains the value expected
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value contained in the row. Any trailing whitespace is ignored
      def assert_row_like(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        assert actual.include?(expected),
               "expected row #{row_number} to be like #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row does not contain the value expected
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value contained in the row. Any trailing whitespace is ignored
      def refute_row_like(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        refute actual.include?(expected),
               "expected row #{row_number} to not be like #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row starts with expected string
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
      def assert_row_starts_with(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        assert actual.start_with?(expected),
               "expected row #{row_number} to start with #{expected.inspect} and got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row does not start with expected string
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
      def refute_row_starts_with(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        refute actual.start_with?(expected),
               "expected row #{row_number} to not start with #{expected.inspect} and got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row end with expected
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
      def assert_row_ends_with(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        assert actual.end_with?(expected),
               "expected row #{row_number} to end with #{expected.inspect} and got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts the contents of a single row don't end with expected
      # @param [Integer] row_number the row (starting from 0) to test against
      # @param [String] expected the expected value that the row starts with. Any trailing whitespace is ignored
      def refute_row_ends_with(row_number, expected)
        expected = expected.rstrip
        actual = row(row_number)
        refute actual.end_with?(expected),
               "expected row #{row_number} to not end with #{expected.inspect} and got #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts that the cursor is in the expected position
      # @param [Integer] x cursor x (row) position, starting from 0
      # @param [Integer] y cursor y (column) position, starting from 0
      def assert_cursor_position(x, y)
        expected = [x, y]
        actual = [cursor_x, cursor_y]
        assert actual == expected,
               "expected cursor to be at #{expected.inspect} but was at #{actual.inspect}\nEntire screen:\n#{self}"
      end

      # Asserts that the cursor is not in the expected position
      # @param [Integer] x cursor x (row) position, starting from 0
      # @param [Integer] y cursor y (column) position, starting from 0
      def refute_cursor_position(x, y)
        expected = [x, y]
        actual = [cursor_x, cursor_y]
        refute actual == expected,
               "expected cursor to not be at #{expected.inspect} but was at #{actual.inspect}\nEntire screen:\n#{self}"
      end

      def assert_cursor_visible
        assert cursor_visible?,
               "expected cursor to be visible but was hidden\nEntire screen:\n#{self}"
      end

      def refute_cursor_visible
        refute cursor_visible?,
               "expected cursor to be hidden but was visible\nEntire screen:\n#{self}"
      end

      def assert_cursor_hidden
        assert cursor_hidden?,
               "expected cursor to be hidden but was visible\nEntire screen:\n#{self}"
      end

      def assert_cursor_hidden
        refute cursor_hidden?,
               "expected cursor to be visible but was hidden\nEntire screen:\n#{self}"
      end

      # Asserts the full contents of the terminal
      # @param [String] expected the full expected contents of the terminal. Trailing whitespace on each line is ignored
      # @raise [MatchError] if the terminal doesn't match the expected content
      def assert_contents(expected)
        expected_rows = expected.split("\n")
        diff = []
        matched = true
        rows.each_with_index do |actual_row, index|
          expected_row = (expected_rows[index] || '').rstrip
          if actual_row != expected_row
            diff << "-#{expected_row}"
            diff << "+#{actual_row}"
            matched = false
          else
            diff << " #{actual_row}".rstrip
          end
        end

        assert matched,
               "screen did not match expected content:\n--- expected\n+++ actual\n#{diff.join("\n")}"
      end
      alias assert_matches assert_contents

      METHODS = public_instance_methods
    end
  end
end
