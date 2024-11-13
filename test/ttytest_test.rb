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
end
