# frozen_string_literal: true

module TTYtest
  # Represents the complete state of a {TTYtest::Terminal} at the time it was captured, including contents, cursor position, etc.
  # @attr_reader [Integer] width The number of columns in the captured terminal.
  # @attr_reader [Integer] height The number of rows in the captured terminal.
  # @attr_reader [Integer] cursor_x The cursor's column (starting at 0) in the captured terminal.
  # @attr_reader [Integer] cursor_y The cursor's row (starting at 0) in the captured terminal.
  class Capture
    include TTYtest::Matchers

    attr_reader :cursor_x, :cursor_y, :width, :height

    # Used internally by drivers when called by {Terminal#capture}
    # @api private
    def initialize(contents, cursor_x: 0, cursor_y: 0, width: nil, height: nil, cursor_visible: true)
      @rows = "#{contents}\nEND".split("\n")[0...-1].map do |row|
        row || ''
      end
      @cursor_x = cursor_x
      @cursor_y = cursor_y
      @width = width
      @height = height
      @cursor_visible = cursor_visible
    end

    # @return [Array<String>] An array of each row's contents from the captured terminal.
    attr_reader :rows

    # @param [Integer] The row to return
    # @return [String] The content of the row from the captured terminal.
    def row(row_number)
      rows[row_number]
    end

    # @return [true,false] Whether the cursor is visible in the captured terminal.
    def cursor_visible?
      @cursor_visible
    end

    # @return [true,false] Whether the cursor is hidden in the captured terminal.
    def cursor_hidden?
      !cursor_visible?
    end

    # @return [Capture] Returns self
    def capture
      self
    end

    # Prints out the current terminal contents.
    def print
      puts "\n#{self}"
    end

    # Prints out the current terminal contents as an array of strings separated by lines.
    def print_rows
      p rows
    end

    # @return [String] All rows of the captured terminal, separated by newlines.
    def to_s
      rows.join("\n")
    end
  end
end
