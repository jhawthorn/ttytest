require 'test_helper'

module TTYtest
  class MatchersTest < Minitest::Test
    def setup
      @dummy = TTYtest::Dummy.new
      @terminal = TTYtest::Terminal.new(@dummy, synchronize: false)
    end

    def test_assert_row_success
      @dummy.contents = "foo\nbar\nbaz"
      @terminal.assert_row(0, "foo")
      @terminal.assert_row(1, "bar")
      @terminal.assert_row(2, "baz")
    end

    def test_assert_row_failure
      assert_raises TTYtest::MatchError do
        @terminal.assert_row(0, "foo")
      end
    end

    def test_assert_cursor_position_success
      @terminal.assert_cursor_position(0, 0)

      @dummy.cursor_position = [1,2]
      @terminal.assert_cursor_position(1, 2)
    end

    def test_assert_cursor_position_failure
      assert_raises TTYtest::MatchError do
        @terminal.assert_cursor_position(1, 1)
      end

      @dummy.cursor_position = [1,2]
      assert_raises TTYtest::MatchError do
        @terminal.assert_cursor_position(0, 0)
      end
    end
  end
end
