module TTYtest
  module Matchers
    # Asserts the contents of a single row
    # @param [Integer] row_number the row (starting from 0) to test against
    # @param [String] expected the expected value of the row. Any trailing whitespace is ignored
    # @raise [MatchError] if the row doesn't match
    def assert_row(row_number, expected)
      expected = expected.rstrip
      actual = row(row_number)
      if actual != expected
        raise MatchError, "expected row #{row_number} to be #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{to_s}"
      end
    end

    # Asserts that the cursor is in the expected position
    # @param [Integer] x cursor x (row) position, starting from 0
    # @param [Integer] y cursor y (column) position, starting from 0
    # @raise [MatchError] if the cursor position doesn't match
    def assert_cursor_position(x:, y:)
      expected = [x, y]
      actual = [cursor_x, cursor_y]
      if actual != expected
        raise MatchError, "expected cursor to be at #{expected.inspect} but was at #{actual.inspect}\nEntire screen:\n#{to_s}"
      end
    end

    # @raise [MatchError] if the cursor is hidden
    def assert_cursor_visible
      if !cursor_visible?
        raise MatchError, "expected cursor to be visible was hidden\nEntire screen:\n#{to_s}"
      end
    end

    # @raise [MatchError] if the cursor is visible
    def assert_cursor_hidden
      if !cursor_hidden?
        raise MatchError, "expected cursor to be hidden was visible\nEntire screen:\n#{to_s}"
      end
    end

    # Asserts the full contents of the terminal
    # @param [String] expected the full expected contents of the terminal. Trailing whitespace on each line is ignored
    # @raise [MatchError] if the terminal doesn't match the expected content
    def assert_contents(expected)
      expected_rows = expected.split("\n")
      diff = []
      matched = true
      rows.each_with_index do |actual_row, index|
        expected_row = (expected_rows[index] || "").rstrip
        if actual_row != expected_row
          diff << "-#{expected_row}"
          diff << "+#{actual_row}"
          matched = false
        else
          diff << " #{actual_row}".rstrip
        end
      end

      if !matched
        raise MatchError, "screen did not match expected content:\n--- expected\n+++ actual\n#{diff.join("\n")}"
      end
    end
    alias_method :assert_matches, :assert_contents

    METHODS = public_instance_methods
  end
end
