module TTYtest
  class Session
    def rows(first, last)
      capture.split("\n")[first..last]
    end

    def row(row)
      rows(row, row)
    end
  end
end
