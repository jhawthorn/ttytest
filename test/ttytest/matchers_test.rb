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

    def test_assert_row_trailing_whitespace
      @capture = Capture.new("")
      @capture.assert_row(0, " ")
      @capture.assert_row(0, "   ")

      @capture = Capture.new("foo")
      @capture.assert_row(0, "foo ")
      @capture.assert_row(0, "foo  ")
      @capture.assert_row(0, "foo   ")

      @capture = Capture.new(" foo")
      @capture.assert_row(0, " foo")
      @capture.assert_row(0, " foo ")
      assert_raises TTYtest::MatchError do
        @capture.assert_row(0, "foo")
      end
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

    def test_assert_matches_success
      @capture = Capture.new(EMPTY)
      @capture.assert_matches("")
      @capture.assert_matches("\n")
      @capture.assert_matches <<TERM
TERM

      @capture = Capture.new <<TERM
$ echo "Hello, world
Hello, world


TERM
      @capture.assert_matches <<TERM
$ echo "Hello, world
Hello, world
TERM
    end

    def test_assert_matches_failure
      @capture = Capture.new("\n\n\n")
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_matches <<TERM
$ echo "Hello, world"
TERM
      end
      assert_equal ex.message, <<TERM
screen did not match expected content:
--- expected
+++ actual
-$ echo "Hello, world"
+


TERM
    end
  end
end
