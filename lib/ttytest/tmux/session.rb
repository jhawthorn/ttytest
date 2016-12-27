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
        driver.tmux(*%W[capture-pane -t #{name} -p])
      end

      def send_keys(*keys)
        driver.tmux(*%W[send-keys -t #{name}], *keys)
      end

      def send_raw(*keys)
        driver.tmux(*%W[send-keys -t #{name} -l], *keys)
      end

      def cursor_position
        str = driver.tmux(*%W[display-message -t #{name} -p #\{cursor_x},#\{cursor_y}])
        str.split(',').map(&:to_i)
      end
    end
  end
end
