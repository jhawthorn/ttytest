require 'test_helper'

module TTYtest
  class MatchersTest < Minitest::Test
    EMPTY = "\n"*23
    def test_assert_row_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n"*21)
      @capture.assert_row(0, "foo")
      @capture.assert_row(1, "bar")
      @capture.assert_row(2, "baz")
      @capture.assert_row(3, "")
    end

    def test_assert_row_failure
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row(0, "foo")
      end
      assert_includes ex.message, 'expected row 0 to be "foo" but got ""'
    end

    def test_assert_cursor_position_success
      @capture = Capture.new(EMPTY)
      @capture.assert_cursor_position(y: 0, x: 0)

      @capture = Capture.new(EMPTY, cursor_y: 2, cursor_x: 1)
      @capture.assert_cursor_position(y: 2, x: 1)
    end

    def test_assert_cursor_position_failure
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(y: 1, x: 1)
      end
      assert_includes ex.message, 'expected cursor to be at [1, 1] but was at [0, 0]'

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 2)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(y: 0, x: 0)
      end
      assert_includes ex.message, 'expected cursor to be at [0, 0] but was at [1, 2]'
    end
  end
end
