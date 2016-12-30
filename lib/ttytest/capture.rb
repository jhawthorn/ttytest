module TTYtest
  class Capture
    include TTYtest::Matchers

    attr_reader :cursor_x, :cursor_y
    attr_reader :width, :height

    def initialize(contents, cursor_x: 0, cursor_y: 0, width: nil, height: nil, cursor_visible: true)
      @rows = (contents+"\nEND").split("\n")[0...-1].map do |row|
        row || ""
      end
      @cursor_x = cursor_x
      @cursor_y = cursor_y
      @width = width
      @height = height
      @cursor_visible = cursor_visible
    end

    def rows
      @rows
    end

    def row(row)
      rows[row]
    end

    def cursor_visible?
      @cursor_visible
    end

    def cursor_hidden?
      !cursor_visible?
    end

    def capture
      self
    end

    def to_s
      rows.join("\n")
    end
  end
end
