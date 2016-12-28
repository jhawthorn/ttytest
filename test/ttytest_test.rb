require "test_helper"

class TTYtestTest < Minitest::Test
  def test_shell_hello_world
    @tty = TTYtest.driver.new_terminal(%{PS1='$ ' /bin/sh})
    @tty.assert_row(0, '$')
    @tty.send_raw('echo "Hello, world"')
    @tty.assert_row(0, '$ echo "Hello, world"')
    @tty.send_keys("Enter")
    @tty.assert_row(1, 'Hello, world')

    @tty.assert_row(2, '$')
    @tty.assert_cursor_position(2, 2)
  end
end
