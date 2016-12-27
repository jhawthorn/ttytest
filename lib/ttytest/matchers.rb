module TTYtest
  module Matchers
    def assert_row(row_number, expected)
      actual = row(row_number)
      if actual != expected
        raise MatchError, "expected row #{row_number} to be #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{to_s}"
      end
    end

    def assert_cursor_position(x, y)
      expected = [x, y]
      actual = cursor_position
      if actual != expected
        raise MatchError, "expected cursor to be at #{expected.inspect} but was at #{actual.inspect}\nEntire screen:\n#{to_s}"
      end
    end

    METHODS = public_instance_methods
  end
end
