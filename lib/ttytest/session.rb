require 'ttytest/matchers'

module TTYtest
  class Session
    include TTYtest::Matchers

    def rows(first, last)
      capture.split("\n")[first..last]
    end

    def row(row)
      capture.split("\n")[row]
    end
  end
end
