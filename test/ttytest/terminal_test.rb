# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class TerminalTest < Minitest::Test
    def hello_world_test_helper
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      assert !@tty.nil?
      @tty.assert_row(0, '$')
      @tty.send_keys('echo "Hello, world"')
      @tty.assert_row(0, '$ echo "Hello, world"')
      @tty.send_newline
      @tty.assert_row(1, 'Hello, world')
      @tty.assert_row(2, '$')
      @tty.assert_cursor_position(2, 2)
      @tty
    end

    def test_shell_hello_world
      hello_world_test_helper
    end

    def test_command_exiting
      @tty = TTYtest.new_terminal(%(printf "foo\nbar\n"))
      @tty.assert_row(0, 'foo')
      @tty.assert_row(1, 'bar')
      @tty.assert_row(2, '')
      @tty.assert_cursor_position(0, 2)
    end

    def empty_command_test_helper(input)
      tty = TTYtest.new_terminal(input)
      tty.assert_cursor_position(0, 0)
      tty.assert_contents ''
    end

    def test_empty_commands
      empty_command_test_helper('')
      empty_command_test_helper(' ')
      empty_command_test_helper('\n')
    end

    def assert_terminal_dimensions(tty, width, height)
      assert_equal width, tty.width
      assert_equal height, tty.height
      assert_equal height, tty.rows.length
    end

    def terminal_dimensions_test_helper(width, height)
      tty = TTYtest.new_terminal('', width: width, height: height)
      assert_terminal_dimensions(tty, width, height)
    end

    def test_terminal_dimenstions
      @tty = TTYtest.new_terminal('')
      assert_terminal_dimensions(@tty, 80, 24)

      terminal_dimensions_test_helper(80, 24)
      terminal_dimensions_test_helper(80, 10)
      terminal_dimensions_test_helper(10, 24)
      terminal_dimensions_test_helper(10, 10)
      terminal_dimensions_test_helper(10, 10)
    end

    def assert_cursor_visible(tty)
      tty.assert_cursor_visible
      assert tty.cursor_visible?
      assert !tty.cursor_hidden?
    end

    def test_cursor_visibility
      @tty = TTYtest.new_terminal('read TMP; printf "\033[?25l"; read TMP; printf "\033[?25h"')
      assert_cursor_visible(@tty)

      @tty.send_newline

      @tty.assert_cursor_hidden
      assert @tty.cursor_hidden?
      assert !@tty.cursor_visible?

      @tty.send_newline

      assert_cursor_visible(@tty)
    end

    def cursor_position_test_helper(input, width, height)
      tty = TTYtest.new_terminal(input)
      tty.assert_cursor_position(width, height)
      assert width, tty.cursor_y
      assert height, tty.cursor_x
    end

    def test_cursor_position
      cursor_position_test_helper('', 0, 0)
      cursor_position_test_helper('printf "\033[7;13H"', 12, 6)
      cursor_position_test_helper('printf "\033[5A"', 0, 0)
      cursor_position_test_helper('printf "\033[5B"', 0, 5)
      cursor_position_test_helper('printf "\033[5C"', 5, 0)
      cursor_position_test_helper('printf "\033[5D"', 0, 0)
    end

    def test_clear_screen
      @tty = TTYtest.new_terminal('printf "foo\nbar\nbaz\n"; read TMP; printf "\033[2J"')
      @tty.assert_contents("foo\nbar\nbaz")
      @tty.send_newline
      @tty.assert_contents('')
    end

    def test_send_clear
      @tty = TTYtest.new_terminal('printf "foo\nbar\nbaz\n"; read TMP; printf "\033[2J"')
      @tty.assert_contents("foo\nbar\nbaz")
      @tty.send_clear
      @tty.assert_contents('')
    end

    def test_print
      @tty = hello_world_test_helper
      @tty.print
    end

    def test_print_rows
      @tty = hello_world_test_helper
      @tty.print_rows
    end
  end
end
