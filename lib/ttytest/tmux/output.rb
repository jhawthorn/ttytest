# frozen_string_literal: true

module TTYtest
  module Tmux
    # Contains output functions which build upon basic functionality in session.rb
    module Output
      private

      attr_reader :driver, :name

      # Send line to tmux, no need to worry about newline character
      def send_line(line)
        send_keys_one_at_a_time(line)
        send_newline unless line[-1] == '\n'
      end

      # Send line then sleep for sleep_time
      def send_line_then_sleep(line, sleep_time)
        send_line(line)
        sleep sleep_time
      end

      def send_lines(*lines)
        lines.each do |line|
          send_line(line)
        end
      end

      def send_line_exact(line)
        send_keys_exact(line)
        send_newline unless line[-1] == '\n'
      end

      def send_lines_exact(*lines)
        lines.each do |line|
          send_line_exact(line)
        end
      end

      def send_lines_then_sleep(*lines, sleep_time)
        lines.each do |line|
          send_line(line)
        end
        sleep sleep_time
      end

      def send_line_then_sleep_and_repeat(*lines, sleep_time)
        lines.each do |line|
          send_line_then_sleep(line, sleep_time)
        end
      end

      def send_newline
        driver.tmux(*%W[send-keys -t #{name} -l], %(\n))
      end
      alias send_enter send_newline

      def send_newlines(number_of_times)
        while number_of_times.positive?
          send_newline
          number_of_times -= 1
        end
      end
      alias send_enters send_newlines

      def send_delete
        send_keys_exact(%(DC))
      end

      def send_deletes(number_of_times)
        while number_of_times.positive?
          send_delete
          number_of_times -= 1
        end
      end

      def send_backspace
        send_keys_exact(%(BSpace))
      end

      def send_backspaces(number_of_times)
        while number_of_times.positive?
          send_backspace
          number_of_times -= 1
        end
      end

      def send_right_arrow
        send_keys(TTYtest::RIGHT_ARROW)
      end

      def send_right_arrows(number_of_times)
        while number_of_times.positive?
          send_right_arrow
          number_of_times -= 1
        end
      end

      def send_left_arrow
        send_keys(TTYtest::LEFT_ARROW)
      end

      def send_left_arrows(number_of_times)
        while number_of_times.positive?
          send_left_arrow
          number_of_times -= 1
        end
      end

      def send_up_arrow
        send_keys(TTYtest::UP_ARROW)
      end

      def send_up_arrows(number_of_times)
        while number_of_times.positive?
          send_up_arrow
          number_of_times -= 1
        end
      end

      def send_down_arrow
        send_keys(TTYtest::DOWN_ARROW)
      end

      def send_down_arrows(number_of_times)
        while number_of_times.positive?
          send_down_arrow
          number_of_times -= 1
        end
      end

      def send_home
        send_keys_exact(TTYtest::HOME_KEY)
      end

      def send_end
        send_keys_exact(TTYtest::END_KEY)
      end

      def send_clear
        send_keys_one_at_a_time(TTYtest::CLEAR)
        send_newline
      end

      def send_escape
        send_keys_exact(%(Escape))
      end

      def send_escapes(number_of_times)
        while number_of_times.positive?
          send_escape
          number_of_times -= 1
        end
      end
    end
  end
end
