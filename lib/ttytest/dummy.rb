module TTYtest
  class Dummy
    attr_accessor :contents, :cursor_position

    def initialize
      @contents = "\n"*23
      @cursor_position = [0,0]
    end

    def capture
      x, y = cursor_position
      Capture.new(contents, cursor_x: x, cursor_y: y)
    end

    def synchronize?
      false
    end
  end
end
