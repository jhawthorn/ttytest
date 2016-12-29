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
end
