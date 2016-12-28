require "test_helper"

class TTYtestTest < Minitest::Test
  def test_shell_hello_world
    @tty = TTYtest.new_terminal(%{PS1='$ ' /bin/sh})
    @tty.assert_row(0, '$')
    @tty.send_keys('echo "Hello, world"')
    @tty.assert_row(0, '$ echo "Hello, world"')
    @tty.send_keys("\n")
    @tty.assert_row(1, 'Hello, world')

    @tty.assert_row(2, '$')
    @tty.assert_cursor_position(y: 2, x: 2)
  end

  def test_command_exiting
    @tty = TTYtest.new_terminal(%{echo "foo\nbar"})
    @tty.assert_row(0, 'foo')
    @tty.assert_row(1, 'bar')
    @tty.assert_row(2, '')
    @tty.assert_cursor_position(y: 2, x: 0)
  end
end
