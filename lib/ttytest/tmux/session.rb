# frozen_string_literal: true

module TTYtest
  module Tmux
    class Session
      attr_reader :driver, :name

      def initialize(driver, name)
        @driver = driver
        @name = name

        ObjectSpace.define_finalizer(self, self.class.finalize(driver, name))
      end

      def self.finalize(driver, name)
        proc { driver.tmux(*%W[kill-session -t #{name}]) }
      end

      def capture
        contents = driver.tmux(*%W[capture-pane -t #{name} -p])
        str = driver.tmux(*%W[display-message -t #{name} -p #\{cursor_x},#\{cursor_y},#\{cursor_flag},#\{pane_width},#\{pane_height}])
        x, y, cursor_flag, width, height = str.split(',')
        TTYtest::Capture.new(
          contents.chomp("\n"),
          cursor_x: x.to_i,
          cursor_y: y.to_i,
          width: width.to_i,
          height: height.to_i,
          cursor_visible: (cursor_flag != '0')
        )
      end

      def send_keys(*keys)
        driver.tmux(*%W[send-keys -t #{name} -l], *keys)
      end
    end
  end
end
