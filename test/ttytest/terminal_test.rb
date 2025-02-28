# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class TerminalTest < Minitest::Test
    def hello_world_test
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

    def hello_world_test_helper
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      hello_world_test
    end

    def test_shell_hello_world
      hello_world_test_helper
    end

    def test_new_sh_terminal_hello_world
      @tty = TTYtest.new_sh_terminal
      hello_world_test
    end

    def test_new_sh_terminal_with_and_height_hello_world
      @tty = TTYtest.new_sh_terminal(width: 40, height: 5)
      hello_world_test
    end

    def test_new_default_sh_terminal_hello_world
      @tty = TTYtest.new_default_sh_terminal
      hello_world_test
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

    def test_max_wait_time
      @tty = TTYtest.new_terminal('')
      @tty.max_wait_time = 1
      assert_equal 1, @tty.max_wait_time
    end

    def test_send_line
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      @tty.assert_row(0, '$')
      @tty.send_line("echo 'Hello, world'")
      @tty.assert_row(1, 'Hello, world')
      @tty.assert_row(2, '$')
    end

    def test_send_line_extra_newline
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      @tty.assert_row(0, '$')
      @tty.send_line("echo 'Hello, world'\n")
      @tty.assert_row(1, 'Hello, world')
      @tty.assert_row(2, '$')
    end

    def test_send_line_empty
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      @tty.assert_row(0, '$')
      @tty.send_line('')
      @tty.assert_row(1, '$')
    end

    def test_typical_example
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 80, height: 7)
      @tty.assert_row(0, '$')
      @tty.assert_cursor_position(2, 0)

      @tty.send_line('echo "Hello, world"')

      @tty.assert_contents <<~TTY
        $ echo "Hello, world"
        Hello, world
        $
      TTY
      @tty.assert_cursor_position(2, 2)

      @tty.assert_contents_at(0, 0, '$ echo "Hello, world"')

      @tty.assert_row_starts_with(0, '$ echo')
      @tty.assert_row_ends_with(0, '"Hello, world"')
      @tty.assert_row_starts_with(1, 'Hello')
      @tty.assert_row_ends_with(1, ', world')

      @tty.print_rows # => ["$ echo \"Hello, world\"", "Hello, world", "$", "", "", "", ""]

      @tty.print # prints out the contents of the terminal:
      # $ echo "Hello, world"
      # Hello, world
      # $
    end

    def test_send_lines
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      @tty.assert_row(0, '$')
      @tty.send_lines('echo hello', 'echo world')
      @tty.assert_row(0, '$ echo hello')
      @tty.assert_row(1, 'hello')
      @tty.assert_row(2, '$ echo world')
      @tty.assert_row(3, 'world')
    end

    def test_send_lines_then_sleep
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      @tty.assert_row(0, '$')
      @tty.send_lines_then_sleep('echo hello', 'echo world', 0.1)
      @tty.assert_row(0, '$ echo hello')
      @tty.assert_row(1, 'hello')
      @tty.assert_row(2, '$ echo world')
      @tty.assert_row(3, 'world')
    end

    def test_send_line_then_sleep_and_repeat
      @tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 40, height: 5)
      @tty.assert_row(0, '$')
      @tty.send_line_then_sleep_and_repeat('echo hello', 'echo world', 0.1)
      @tty.assert_row(0, '$ echo hello')
      @tty.assert_row(1, 'hello')
      @tty.assert_row(2, '$ echo world')
      @tty.assert_row(3, 'world')
    end
  end
end
