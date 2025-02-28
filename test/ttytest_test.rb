# frozen_string_literal: true

require 'test_helper'

class TTYtestTest < Minitest::Test
  def test_default_driver
    assert_instance_of TTYtest::Tmux::Driver, TTYtest.driver
  end

  def test_default_max_wait_time
    assert_equal 2, TTYtest.default_max_wait_time
  end

  def test_new_terminal
    assert_instance_of TTYtest::Terminal, TTYtest.new_terminal('')
  end

  def test_new_terminal_with_height_and_width
    assert_instance_of TTYtest::Terminal, TTYtest.new_terminal('', width: 40, height: 12)
  end

  def test_new_sh_terminal
    assert_instance_of TTYtest::Terminal, TTYtest.new_sh_terminal
  end

  def test_new_sh_terminal_with_height_and_width
    assert_instance_of TTYtest::Terminal, TTYtest.new_sh_terminal(width: 40, height: 12)
  end

  def test_new_default_sh_terminal
    assert_instance_of TTYtest::Terminal, TTYtest.new_default_sh_terminal
  end

  def test_set_max_wait_time
    @tty = TTYtest.new_terminal('')
    @tty.max_wait_time = 1
    assert_equal 1, @tty.max_wait_time
    @tty.max_wait_time = 3
    assert_equal 3, @tty.max_wait_time
  end
end
