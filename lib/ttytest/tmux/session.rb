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
        str = driver.tmux(*%W[display-message -t #{name} -p #\{cursor_x},#\{cursor_y},#\{cursor_flag}])
        x, y, cursor_flag = str.split(',').map(&:to_i)
        cursor_visible = (cursor_flag != 0)
        TTYtest::Capture.new(contents, cursor_x: x, cursor_y: y, cursor_visible: cursor_visible)
      end

      def send_keys(*keys)
        driver.tmux(*%W[send-keys -t #{name} -l], *keys)
      end
    end
  end
end
