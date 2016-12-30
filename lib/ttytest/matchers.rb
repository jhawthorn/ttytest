module TTYtest
  module Matchers
    def assert_row(row_number, expected)
      actual = row(row_number)
      if actual != expected
        raise MatchError, "expected row #{row_number} to be #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{to_s}"
      end
    end

    def assert_cursor_position(x:, y:)
      expected = [x, y]
      actual = [cursor_x, cursor_y]
      if actual != expected
        raise MatchError, "expected cursor to be at #{expected.inspect} but was at #{actual.inspect}\nEntire screen:\n#{to_s}"
      end
    end

    def assert_cursor_visible
      if !cursor_visible?
        raise MatchError, "expected cursor to be visible was hidden\nEntire screen:\n#{to_s}"
      end
    end

    def assert_cursor_hidden
      if !cursor_hidden?
        raise MatchError, "expected cursor to be hidden was visible\nEntire screen:\n#{to_s}"
      end
    end

    def assert_matches(expected)
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

    METHODS = public_instance_methods
  end
end
