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
      ex = assert_raises TTYtest::MatchError do
        @terminal.assert_row(0, "foo")
      end
      assert_includes ex.message, 'expected row 0 to be "foo" but got nil'
    end

    def test_assert_cursor_position_success
      @terminal.assert_cursor_position(0, 0)

      @dummy.cursor_position = [1,2]
      @terminal.assert_cursor_position(1, 2)
    end

    def test_assert_cursor_position_failure
      ex = assert_raises TTYtest::MatchError do
        @terminal.assert_cursor_position(1, 1)
      end
      assert_includes ex.message, 'expected cursor to be at [1, 1] but was at [0, 0]'

      @dummy.cursor_position = [1,2]
      ex = assert_raises TTYtest::MatchError do
        @terminal.assert_cursor_position(0, 0)
      end
      assert_includes ex.message, 'expected cursor to be at [0, 0] but was at [1, 2]'
    end
  end
end
