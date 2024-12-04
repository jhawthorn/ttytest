# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class CaptureTest < Minitest::Test
    def test_rows
      @capture = Capture.new("0\n1\n2\n3")
      assert_equal %w[0 1 2 3], @capture.rows
    end

    def test_row
      @capture = Capture.new("0\n1\n2\n3")
      assert_equal '0', @capture.row(0)
      assert_equal '1', @capture.row(1)
      assert_equal '2', @capture.row(2)
      assert_equal '3', @capture.row(3)
    end

    def test_cursor_visibility
      @capture = Capture.new('', cursor_visible: true)
      assert @capture.cursor_visible?
      assert !@capture.cursor_hidden?

      @capture = Capture.new('', cursor_visible: false)
      assert !@capture.cursor_visible?
      assert @capture.cursor_hidden?
    end

    def test_dimensions
      # If unspecified, dimensions are nil
      @capture = Capture.new('')
      assert_nil @capture.width
      assert_nil @capture.height

      @capture = Capture.new('', width: 80, height: 24)
      assert_equal 80, @capture.width
      assert_equal 24, @capture.height
    end

    def test_to_s
      @capture = Capture.new("0\n1\n2\n3\n", width: 20, height: 5)
      assert_equal <<~TERM, @capture.to_s
        0
        1
        2
        3
      TERM
    end

    def test_print
      @capture = @capture = Capture.new("0\n1\n2\n3\n", width: 20, height: 5)
      puts
      @capture.print
    end

    def test_print_rows
      @capture = @capture = Capture.new("0\n1\n2\n3\n", width: 20, height: 5)
      puts
      @capture.print_rows
    end
  end
end
