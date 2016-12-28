require 'test_helper'

module TTYtest
  class TerminalTest < Minitest::Test
    def setup
      @dummy = TTYtest::Dummy.new
      @terminal = TTYtest::Terminal.new(@dummy, max_wait_time: 0)
    end

    def rows_test
      assert_equal 24, terminal.rows.length
      assert_equal [""] * 24, terminal.rows

      @dummy.contents = "foo\nbar\nbaz" + "\n"*21
      assert_equal 24, terminal.rows.length
      assert_equal ["foo", "bar", "baz"] + [""]*21, terminal.rows.length
    end
  end
end
