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

    METHODS = public_instance_methods
  end
end
