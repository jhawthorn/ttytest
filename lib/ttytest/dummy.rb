module TTYtest
  class Dummy
    attr_accessor :contents

    def initialize
      @contents = "\n"*23
    end

    def capture
      Capture.new(contents)
    end
  end
end
