require "test_helper"

class TTYtestTest < Minitest::Test
  def test_shell_hello_world
    @terminal = TTYtest.driver.new_terminal(%{PS1='$ ' /bin/sh})
    @terminal.assert_row(0, '$')
    @terminal.send_raw('echo "Hello, world"')
    @terminal.assert_row(0, '$ echo "Hello, world"')
    @terminal.send_keys("Enter")
    @terminal.assert_row(1, 'Hello, world')

    @terminal.assert_row(2, '$')
    assert_equal [2, 2], @terminal.cursor_position
  end
end
