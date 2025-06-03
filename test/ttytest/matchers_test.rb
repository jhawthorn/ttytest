# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class MatchersTest < Minitest::Test
    EMPTY = "\n" * 23

    def test_assert_row_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row(0, 'foo')
      @capture.assert_row(1, 'bar')
      @capture.assert_row(2, 'baz')
      @capture.assert_row(3, '')
      @capture.assert_row(4, '')
    end

    def test_assert_row_failure
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row(0, 'foo')
      end
      assert_includes ex.message, 'expected row 0 to be "foo" but got ""'
    end

    def test_assert_row_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row(0, ' ')
      @capture.assert_row(0, "\n")
      @capture.assert_row(0, '   ')
      @capture.assert_row(0, "   \n")

      @capture = Capture.new('foo')
      @capture.assert_row(0, 'foo ')
      @capture.assert_row(0, 'foo  ')
      @capture.assert_row(0, 'foo   ')
      @capture.assert_row(0, "foo\n")

      @capture = Capture.new(' foo')
      @capture.assert_row(0, ' foo ')
      @capture.assert_row(0, ' foo  ')
      @capture.assert_row(0, " foo\n")
      @capture.assert_row(0, " foo  \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row(0, 'foo')
      end
    end

    def test_assert_row_nil_failure
      @capture = Capture.new(nil)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row(0, 'foo')
      end
      assert_includes ex.message, 'expected row 0 to be "foo" but got ""'
    end

    def test_assert_row_is_empty_success
      @capture = Capture.new(EMPTY)
      @capture.assert_row_is_empty(0)
      @capture.assert_row_is_empty(1)
      @capture.assert_row_is_empty(2)
      @capture.assert_row_is_empty(3)
      @capture.assert_row_is_empty(4)
    end

    def test_assert_row_is_empty_failure
      @capture = Capture.new("foo\nfoo\n")
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_row_is_empty(0)
      end
      assert_includes ex.message, 'expected row 0 to be empty'
    end

    def test_assert_row_at_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row_at(0, 0, 0, 'f')
      @capture.assert_row_at(0, 0, 1, 'fo')
      @capture.assert_row_at(0, 0, 2, 'foo')
      @capture.assert_row_at(0, 1, 2, 'oo')
      @capture.assert_row_at(0, 2, 2, 'o')

      @capture.assert_row_at(1, 0, 0, 'b')
      @capture.assert_row_at(1, 0, 1, 'ba')
      @capture.assert_row_at(1, 0, 2, 'bar')
      @capture.assert_row_at(1, 1, 2, 'ar')
      @capture.assert_row_at(1, 2, 2, 'r')

      @capture.assert_row_at(2, 0, 0, 'b')
      @capture.assert_row_at(2, 0, 1, 'ba')
      @capture.assert_row_at(2, 0, 2, 'baz')
      @capture.assert_row_at(2, 1, 2, 'az')
      @capture.assert_row_at(2, 2, 2, 'z')

      @capture.assert_row_at(3, 0, 0, '')
    end

    def test_assert_row_at_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_at(0, 0, 2, 'foo')
      end
    end

    def test_assert_row_at_nil_failure
      @capture = Capture.new(nil)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_at(0, 0, 2, 'foo')
      end
    end

    def test_assert_row_at_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row_at(0, 0, 0, "\n")
      @capture.assert_row_at(0, 0, 0, ' ')
      @capture.assert_row_at(0, 0, 0, '   ')
      @capture.assert_row_at(0, 0, 0, "   \n")

      @capture = Capture.new('foo')
      @capture.assert_row_at(0, 1, 2, "oo\n")
      @capture.assert_row_at(0, 1, 2, 'oo ')
      @capture.assert_row_at(0, 2, 2, 'o  ')
      @capture.assert_row_at(0, 0, 2, 'foo   ')
      @capture.assert_row_at(0, 0, 2, "foo   \n")

      @capture = Capture.new(' foo')
      @capture.assert_row_at(0, 0, 2, ' fo')
      @capture.assert_row_at(0, 0, 2, ' fo ')
      @capture.assert_row_at(0, 1, 3, 'foo ')
      @capture.assert_row_at(0, 1, 3, "foo\n")
      @capture.assert_row_at(0, 0, 3, ' foo ')
      @capture.assert_row_at(0, 0, 3, " foo \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_at(0, 0, 2, 'bar')
      end
    end

    def test_assert_row_like_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row_like(0, 'fo')
      @capture.assert_row_like(0, 'oo')
      @capture.assert_row_like(0, 'f')
      @capture.assert_row_like(1, 'ba')
      @capture.assert_row_like(1, 'ar')
      @capture.assert_row_like(1, 'a')
      @capture.assert_row_like(2, 'az')
      @capture.assert_row_like(2, 'ba')
      @capture.assert_row_like(2, 'z')
      @capture.assert_row_like(3, '')
    end

    def test_assert_row_like_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_like(0, 'foo')
      end
    end

    def test_assert_row_like_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row_like(0, "\n")
      @capture.assert_row_like(0, ' ')
      @capture.assert_row_like(0, '   ')
      @capture.assert_row_like(0, "   \n")

      @capture = Capture.new('foo')
      @capture.assert_row_like(0, 'oo ')
      @capture.assert_row_like(0, 'o  ')
      @capture.assert_row_like(0, 'foo   ')
      @capture.assert_row_like(0, "foo\n")
      @capture.assert_row_like(0, "foo   \n")

      @capture = Capture.new(' foo')
      @capture.assert_row_like(0, ' fo ')
      @capture.assert_row_like(0, 'foo ')
      @capture.assert_row_like(0, ' foo ')
      @capture.assert_row_like(0, " foo \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_like(0, 'bar')
      end
    end

    def test_assert_row_starts_with_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row_starts_with(0, 'f')
      @capture.assert_row_starts_with(0, 'fo')
      @capture.assert_row_starts_with(0, 'foo')

      @capture.assert_row_starts_with(1, 'b')
      @capture.assert_row_starts_with(1, 'ba')
      @capture.assert_row_starts_with(1, 'bar')

      @capture.assert_row_starts_with(2, 'b')
      @capture.assert_row_starts_with(2, 'ba')
      @capture.assert_row_starts_with(2, 'baz')

      @capture.assert_row_starts_with(3, '')
    end

    def test_assert_row_starts_with_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_starts_with(0, 'bar')
      end
    end

    def test_assert_row_starts_with_trailing_whitespace
      @capture = Capture.new('')
      @capture.assert_row_starts_with(0, "\n")
      @capture.assert_row_starts_with(0, "  \n")
      @capture.assert_row_starts_with(0, ' ')
      @capture.assert_row_starts_with(0, '   ')

      @capture = Capture.new('foo')
      @capture.assert_row_starts_with(0, 'f ')
      @capture.assert_row_starts_with(0, "f  \n")
      @capture.assert_row_starts_with(0, 'fo ')
      @capture.assert_row_starts_with(0, 'fo  ')

      @capture = Capture.new(' foo')
      @capture.assert_row_starts_with(0, ' f ')
      @capture.assert_row_starts_with(0, ' fo ')
      @capture.assert_row_starts_with(0, ' foo ')
      @capture.assert_row_starts_with(0, " foo \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_starts_with(0, 'foo')
      end
    end

    def test_assert_row_ends_with_success
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row_ends_with(0, 'o')
      @capture.assert_row_ends_with(0, 'oo')
      @capture.assert_row_ends_with(0, 'foo')

      @capture.assert_row_ends_with(1, 'r')
      @capture.assert_row_ends_with(1, 'ar')
      @capture.assert_row_ends_with(1, 'bar')

      @capture.assert_row_ends_with(2, 'z')
      @capture.assert_row_ends_with(2, 'az')
      @capture.assert_row_ends_with(2, 'baz')

      @capture.assert_row_ends_with(3, '')
    end

    def test_assert_row_ends_with_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_ends_with(0, 'bar')
      end
    end

    def test_assert_row_ends_with_trailing_whitespace
      @capture = Capture.new('foo')
      @capture.assert_row_ends_with(0, 'o ')
      @capture.assert_row_ends_with(0, 'oo  ')
      @capture.assert_row_ends_with(0, 'foo   ')
      @capture.assert_row_ends_with(0, "foo   \n")

      @capture = Capture.new(' foo')
      @capture.assert_row_ends_with(0, ' foo ')
      @capture.assert_row_ends_with(0, 'foo ')
      @capture.assert_row_ends_with(0, 'oo ')
      @capture.assert_row_ends_with(0, 'o ')
      @capture.assert_row_ends_with(0, "o \n")
      assert_raises TTYtest::MatchError do
        @capture.assert_row_ends_with(0, 'bar')
      end
    end

    def test_assert_row_regexp_success
      @capture = Capture.new(EMPTY)
      @capture.assert_row_regexp(0, '')

      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_row_regexp(0, 'foo')
      @capture.assert_row_regexp(0, '[o]')
      @capture.assert_row_regexp(1, 'bar')
      @capture.assert_row_regexp(1, '[a]')
      @capture.assert_row_regexp(2, 'baz')
      @capture.assert_row_regexp(2, '[z]')
      @capture.assert_row_regexp(3, '')
    end

    def test_assert_row_regexp_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_row_regexp(0, '[o]')
      end
    end

    def test_assert_rows_each_match_regexp_success
      @capture = Capture.new(EMPTY)

      @capture = Capture.new("foo\nfoo\nfoo\n")
      @capture.assert_rows_each_match_regexp(0, 2, 'foo')
      @capture.assert_rows_each_match_regexp(0, 2, '[o]')
      @capture.assert_rows_each_match_regexp(0, 2, '[f]')
    end

    def test_assert_rows_each_match_regexp_failure
      @capture = Capture.new(EMPTY)
      assert_raises TTYtest::MatchError do
        @capture.assert_rows_each_match_regexp(0, 2, '[o]')
      end

      @capture = Capture.new("foo\nfoo\nfoo\n")

      assert_raises TTYtest::MatchError do
        @capture.assert_rows_each_match_regexp(0, 2, '[a]')
      end

      assert_raises TTYtest::MatchError do
        @capture.assert_rows_each_match_regexp(0, 2, 'ba]')
      end
    end

    def test_assert_cursor_position_success
      @capture = Capture.new(EMPTY)
      @capture.assert_cursor_position(0, 0)

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 0)
      @capture.assert_cursor_position(1, 0)

      @capture = Capture.new(EMPTY, cursor_x: 0, cursor_y: 1)
      @capture.assert_cursor_position(0, 1)

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 2)
      @capture.assert_cursor_position(1, 2)
    end

    def test_assert_cursor_position_failure
      @capture = Capture.new(EMPTY)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(1, 1)
      end
      assert_includes ex.message, 'expected cursor to be at [1, 1] but was at [0, 0]'

      @capture = Capture.new(EMPTY, cursor_x: 1, cursor_y: 2)
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_cursor_position(0, 0)
      end
      assert_includes ex.message, 'expected cursor to be at [0, 0] but was at [1, 2]'
    end

    def test_assert_contents_success
      @capture = Capture.new(EMPTY)
      @capture.assert_contents('')
      @capture.assert_contents("\n")
      @capture.assert_contents <<TERM
TERM

      @capture = Capture.new <<~TERM
        $ echo "Hello, world
        Hello, world


      TERM
      @capture.assert_contents <<~TERM
        $ echo "Hello, world
        Hello, world
      TERM
    end

    def test_assert_contents_failure
      @capture = Capture.new("\n\n\n")
      ex = assert_raises TTYtest::MatchError do
        @capture.assert_contents <<~TERM
          $ echo "Hello, world"
        TERM
      end
      assert_equal ex.message, <<~TERM
        screen did not match expected content:
        --- expected
        +++ actual
        -$ echo "Hello, world"
        +


      TERM
    end

    def test_assert_contents_trailing_whitespace
      @capture = Capture.new(EMPTY)
      @capture.assert_contents(' ')
      @capture.assert_contents('  ')
      @capture.assert_contents("  \n \n")

      @capture = Capture.new('foo')
      @capture.assert_contents('foo')
      @capture.assert_contents('foo  ')
      @capture.assert_contents("foo  \n \n")

      @capture = Capture.new("\nfoo\n")
      @capture.assert_contents("\nfoo")
      @capture.assert_contents("\nfoo ")
      @capture.assert_contents("\nfoo  ")
      @capture.assert_contents("  \nfoo \n ")
    end

    def test_assert_contents_at_success
      @capture = Capture.new(EMPTY)
      @capture.assert_contents_at(0, 0, '')
      @capture.assert_contents_at(0, 0, "\n")
      @capture.assert_contents_at(0, 0, "  \n")
      @capture.assert_contents_at(0, 0, "\n\n\n")

      @capture.assert_contents_at 0, 0, <<TERM
TERM

      @capture = Capture.new <<~TERM
        $ echo "Hello, world"
        Hello, world


      TERM

      @capture.assert_contents_at(0, 0, '$ echo "Hello, world"')
      @capture.assert_contents_at(1, 1, 'Hello, world')

      @capture.assert_contents_at 0, 1, <<~TERM
        $ echo "Hello, world"
        Hello, world
      TERM
    end

    def test_assert_contents_at_success_multiple_lines
      @capture = Capture.new("foo\nbar\nbaz" + "\n" * 21)
      @capture.assert_contents_at(0, 0, 'foo')
      @capture.assert_contents_at(1, 1, 'bar')
      @capture.assert_contents_at(2, 2, 'baz')
      @capture.assert_contents_at(0, 1, "foo\nbar")
      @capture.assert_contents_at(1, 2, "bar\nbaz")
      @capture.assert_contents_at 0, 2, <<~TERM
        foo
        bar
        baz
      TERM

      @capture = Capture.new <<~TERM
        $ echo "Hello, world"
        Hello, world
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 0, 1, <<~TERM
        $ echo "Hello, world"
        Hello, world
      TERM

      @capture.assert_contents_at 1, 2, <<~TERM
        Hello, world
        $ echo "Hello, world"
      TERM

      @capture.assert_contents_at 0, 3, <<~TERM
        $ echo "Hello, world"
        Hello, world
        $ echo "Hello, world"
        Hello, world
      TERM
    end

    def test_assert_contents_at_failure
      @capture = Capture.new("\n\n\n")
      @capture.print_rows
      assert_raises TTYtest::MatchError do
        @capture.assert_contents_at(0, 0, '$ echo "Hello, world"')
      end
    end

    def test_assert_contents_at_trailing_whitespace
      @capture = Capture.new(EMPTY)
      @capture.assert_contents_at(0, 0, "\n")
      @capture.assert_contents_at(0, 0, ' ')
      @capture.assert_contents_at(0, 0, '  ')
      @capture.assert_contents_at(0, 0, "  \n \n")

      @capture = Capture.new('foo')
      @capture.assert_contents_at(0, 0, 'foo')
      @capture.assert_contents_at(0, 0, 'foo  ')
      @capture.assert_contents_at(0, 0, "foo  \n \n")

      @capture = Capture.new("\nfoo\n")
      @capture.assert_contents_at(0, 1, "\nfoo ")
      @capture.assert_contents_at(0, 1, "\nfoo  ")
      @capture.assert_contents_at(0, 1, "  \nfoo \n ")
    end
  end
end
