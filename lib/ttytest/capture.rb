module TTYtest
  class Capture
    include TTYtest::Matchers

    def initialize(contents)
      @rows = (contents+"\nEND").split("\n")[0...-1].map do |row|
        row || ""
      end
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

    def synchronize?
      false
    end
  end
end
