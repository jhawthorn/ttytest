module TTYtest
  module Matchers
    def assert_row(row_number, expected)
      synchronize do
        actual = row(row_number)
        if actual != expected
          raise MatchError, "expected row #{row_number} to be #{expected.inspect} but got #{actual.inspect}\nEntire screen:\n#{capture}"
        end
      end
    end

    def assert_cursor_position(x, y)
      synchronize do
        expected = [x, y]
        actual = cursor_position
        if actual != expected
          raise MatchError, "expected cursor to be at #{expected.inspect} but was at #{actual.inspect}\nEntire screen:\n#{capture}"
        end
      end
    end

    def synchronize(seconds=TTYtest.default_max_wait_time)
      start_time = Time.now
      begin
        yield
      rescue MatchError => e
        raise e unless synchronize?
        raise e if (Time.now - start_time) >= seconds
        sleep 0.05
        retry
      end
    end
  end
end
