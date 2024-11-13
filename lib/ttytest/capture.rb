# frozen_string_literal: true

module TTYtest
  # Represents the complete state of a {TTYtest::Terminal} at the time it was captured (contents, cursor position, etc).
  # @attr_reader [Integer] width the number of columns in the captured terminal
  # @attr_reader [Integer] height the number of rows in the captured terminal
  # @attr_reader [Integer] cursor_x the cursor's column (starting at 0) in the captured terminal
  # @attr_reader [Integer] cursor_y the cursor's row (starting at 0) in the captured terminal
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

    # @return [Array<String>] An array of each row's contend from the captured terminal
    attr_reader :rows

    # @param [Integer] the row to return
    # @return [String] the content of the row from the captured terminal
    def row(row_number)
      rows[row_number]
    end

    # @return [true,false] Whether the cursor is visible in the captured terminal
    def cursor_visible?
      @cursor_visible
    end

    # @return [true,false] Whether the cursor is hidden in the captured terminal
    def cursor_hidden?
      !cursor_visible?
    end

    # @return [Capture] returns self
    def capture
      self
    end

    # @return [String] All rows of the captured terminal, separated by newlines
    def to_s
      rows.join("\n")
    end
  end
end
