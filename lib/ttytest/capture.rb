module TTYtest
  class Capture
    include TTYtest::Matchers

    attr_reader :cursor_position

    def initialize(contents, cursor_position)
      @rows = (contents+"\nEND").split("\n")[0...-1].map do |row|
        row || ""
      end
      @cursor_position = cursor_position
    end

    def rows
      @rows
    end

    def row(row)
      rows[row]
    end

    def capture
      self
    end

    def to_s
      rows.join("\n")
    end
  end
end
