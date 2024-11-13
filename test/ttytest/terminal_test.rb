# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class TerminalTest < Minitest::Test
    def test_shell_hello_world
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh))
      @tty.assert_row(0, '$')
      @tty.send_keys('echo "Hello, world"')
      @tty.assert_row(0, '$ echo "Hello, world"')
      @tty.send_keys("\n")
      @tty.assert_row(1, 'Hello, world')

      @tty.assert_row(2, '$')
      @tty.assert_cursor_position(2, 2)
    end

    def test_command_exiting
      @tty = TTYtest.new_terminal(%(printf "foo\nbar\n"))
      @tty.assert_row(0, 'foo')
      @tty.assert_row(1, 'bar')
      @tty.assert_row(2, '')
      @tty.assert_cursor_position(0, 2)
    end

    def test_empty_commands
      @tty = TTYtest.new_terminal('')
      @tty.assert_cursor_position(0, 0)
      @tty.assert_contents ''

      @tty = TTYtest.new_terminal(' ')
      @tty.assert_cursor_position(0, 0)
      @tty.assert_contents ''

      @tty = TTYtest.new_terminal("\n")
      @tty.assert_cursor_position(0, 0)
      @tty.assert_contents ''
    end

    def test_terminal_dimenstions
      @tty = TTYtest.new_terminal('')
      assert_equal 80, @tty.width
      assert_equal 24, @tty.height
      assert_equal 24, @tty.rows.length

      @tty = TTYtest.new_terminal('', width: 80, height: 24)
      assert_equal 80, @tty.width
      assert_equal 24, @tty.height
      assert_equal 24, @tty.rows.length

      @tty = TTYtest.new_terminal('', width: 80, height: 10)
      assert_equal 80, @tty.width
      assert_equal 10, @tty.height
      assert_equal 10, @tty.rows.length

      @tty = TTYtest.new_terminal('', width: 10, height: 24)
      assert_equal 10, @tty.width
      assert_equal 24, @tty.height
      assert_equal 24, @tty.rows.length

      @tty = TTYtest.new_terminal('', width: 10, height: 10)
      assert_equal 10, @tty.width
      assert_equal 10, @tty.height
      assert_equal 10, @tty.rows.length

      @tty = TTYtest.new_terminal('', width: 10, height: 10)
      assert_equal 10, @tty.width
      assert_equal 10, @tty.height
      assert_equal 10, @tty.rows.length
    end

    def test_cursor_visibility
      @tty = TTYtest.new_terminal('read TMP; printf "\033[?25l"; read TMP; printf "\033[?25h"')
      @tty.assert_cursor_visible
      assert @tty.cursor_visible?
      assert !@tty.cursor_hidden?

      @tty.send_keys("\n")

      @tty.assert_cursor_hidden
      assert @tty.cursor_hidden?
      assert !@tty.cursor_visible?

      @tty.send_keys("\n")

      @tty.assert_cursor_visible
      assert @tty.cursor_visible?
      assert !@tty.cursor_hidden?
    end

    def test_cursor_position
      @tty = TTYtest.new_terminal('')
      @tty.assert_cursor_position(0, 0)
      assert 0, @tty.cursor_y
      assert 0, @tty.cursor_x

      @tty = TTYtest.new_terminal('printf "\033[7;13H"')
      @tty.assert_cursor_position(12, 6)
      assert 6, @tty.cursor_y
      assert 12, @tty.cursor_x

      @tty = TTYtest.new_terminal('printf "\033[5A"')
      @tty.assert_cursor_position(0, 0)

      @tty = TTYtest.new_terminal('printf "\033[5B"')
      @tty.assert_cursor_position(0, 5)

      @tty = TTYtest.new_terminal('printf "\033[5C"')
      @tty.assert_cursor_position(5, 0)

      @tty = TTYtest.new_terminal('printf "\033[5D"')
      @tty.assert_cursor_position(0, 0)
    end

    def test_clear_screen
      @tty = TTYtest.new_terminal('printf "foo\nbar\nbaz\n"; read TMP; printf "\033[2J"')
      @tty.assert_contents("foo\nbar\nbaz")

      @tty.send_keys("\n")

      @tty.assert_contents('')
    end
  end
end
