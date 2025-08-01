# frozen_string_literal: true

require 'forwardable'
require 'ttytest/assertions'
require 'ttytest/capture'

module TTYtest
  # @attr [Integer] max_wait_time The maximum amount of time (in seconds) to retry an assertion before failing and raising a MatchError.
  class Terminal
    extend Forwardable

    attr_accessor :max_wait_time

    # @api private
    # @see TTYtest.new_terminal, use this or other new_* methods instead.
    # Internal constructor.
    def initialize(driver_terminal)
      @driver_terminal = driver_terminal
      @max_wait_time = TTYtest.default_max_wait_time
    end

    # @!method send_keys(*keys)
    #   Simulate typing keys into the terminal. For canonical cli's/shells which read line by line.
    #   @param [String] keys keys to send to the terminal

    # @!method send_keys_one_at_a_time(keys)
    #   Simulate typing keys into the terminal. For noncanonical cli's/shells which read character by character.
    #   @param [String] keys keys to send to the terminal

    # @!method send_line(line)
    #   Simulate sending a line to the terminal and hitting enter.
    #   Can send multiline input, but if you want to send several commands at once, see send_lines(lines)
    #   If no newline is at the the line, it will be appended automatically.
    #   @param [String] line the line to send to the terminal

    # @!method send_line_then_sleep(line, sleep_time)
    #   Simulate sending a line to the terminal and hitting enter, then sleeping for sleep_time.
    #   @param [String] line the line to send to the terminal
    #   @param [Integer] sleep_time the amount of time to sleep after sending the line

    # @!method send_lines(lines)
    #   Simulate sending a multiple lines to the terminal and hitting enter after each line.
    #   If no newline is at the end of any of the lines, it will be appended automatically.
    #   @param [String] lines array of lines to send to the terminal

    # @!method send_line_exact(line)
    #   Simulate sending a line exactly as is to the terminal and hitting enter.
    #   Can send multiline input, but if you want to send several commands at once, see send_lines(lines)
    #   If no newline is at the the line, it will be appended automatically.
    #   @param [String] line the line to send to the terminal

    # @!method send_lines_exact(lines)
    #   Simulate sending a multiple lines exactly as is to the terminal and hitting enter after each line.
    #   If no newline is at the end of any of the lines, it will be appended automatically.
    #   @param [String] lines array of lines to send to the terminal

    # @!method send_lines_then_sleep(lines, sleep_time)
    #   Simulate sending multiples lines to the terminal and hitting enter after each line.
    #   After sending all lines, then wait for the sleep_time.
    #   @param [String] line the line to send to the terminal
    #   @param [Integer] sleep_time the amount of time to sleep after sending the line

    # @!method send_line_then_sleep_and_repeat(lines, sleep_time)
    #   Simulate sending a line to the terminal and hitting enter, then sleeping for sleep_time.
    #   before sending the next line.
    #   @param [String] line the line to send to the terminal
    #   @param [Integer] sleep_time the amount of time to sleep after sending the line

    # @!method send_newline
    #   Simulate typing enter by sending newline character to the terminal.

    # @!method send_newlines(number_of_times)
    #   Simulates sending newline the specified number of times.
    #   @param [Integer] number_of_times number of times to send newline

    # @!method send_enter
    #   Simulate typing enter by sending newline character to the terminal.

    # @!method send_enters(number_of_times)
    #   Simulates sending newline the specified number of times.
    #   @param [Integer] number of times to send newline

    # @!method send_delete
    #   Simulate typing the delete key in the terminal.

    # @!method send_deletes(number_of_times)
    #   Simulates typing delete the specified number of times.
    #   @param [Integer] number of times to send delete

    # @!method send_backspace
    #   Simulate typing the backspace key in the terminal.

    # @!method send_backspaces(number_of_times)
    #   Simulates typing backspace the specified number of times.
    #   @param [Integer] number of times to send backspace

    # @!method send_left_arrow
    #   Simulate typing the left arrow key in the terminal.

    # @!method send_left_arrows(number_of_times)
    #   Simulates typing left arrow the specified number of times.
    #   @param [Integer] number of times to send left arrow

    # @!method send_right_arrow
    #   Simulate typing the right arrow key in the terminal.

    # @!method send_right_arrows(number_of_times)
    #   Simulates typing right arrow the specified number of times.
    #   @param [Integer] number of times to send right arrow

    # @!method send_down_arrow
    #   Simulate typing the down arrow key in the terminal.

    # @!method send_down_arrows(number_of_times)
    #   Simulates typing the down arrow the specified number of times.
    #   @param [Integer] number of times to send down arrow

    # @!method send_up_arrow
    #   Simulate typing the up arrow key in the terminal.

    # @!method send_up_arrows(number_of_times)
    #   Simulates typing the up arrow the specified number of times.
    #   @param [Integer] number of times to send up arrow

    # @!method send_keys_exact(keys)
    #   Send tmux send-keys command to the terminal, such as DC or Enter, to simulate pressing that key in the terminal.
    #   @param [String] keys the line to send to the terminal

    # @!method send_home
    #   Simulates typing in the Home key in the terminal.

    # @!method send_end
    #   Simulates typing in the End key in the terminal.

    # @!method send_clear
    #   Clears the screen in the terminal using ascii clear command.

    # @!method send_escape
    #   Simulates typing in the Escape (ESC) key in the terminal.

    # @!method send_escapes(number_of_times)
    #   Simulates typing in the Escape (ESC) key in the terminal the specified number of times.
    #   @param [Integer] number of times to send escape

    # @!method capture
    #   Capture represents the current state of the terminal.
    #   @return [Capture] The current state of the terminal when called
    def_delegators :@driver_terminal,
                   :send_keys, :send_keys_one_at_a_time,
                   :send_line, :send_line_then_sleep,
                   :send_lines, :send_lines_then_sleep, :send_line_then_sleep_and_repeat,
                   :send_line_exact, :send_lines_exact,
                   :send_newline, :send_newlines,
                   :send_enter, :send_enters,
                   :send_delete, :send_deletes,
                   :send_backspace, :send_backspaces,
                   :send_left_arrow, :send_left_arrows, :send_right_arrow, :send_right_arrows,
                   :send_down_arrow, :send_down_arrows, :send_up_arrow, :send_up_arrows,
                   :send_keys_exact, :send_home, :send_end, :send_clear, :send_escape, :send_escapes,
                   :capture

    # @!method print
    #   Prints the current state of the terminal to stdout. See capture to get the raw string.
    # @!method print_rows
    #   Prints the current state of the terminal as an array to stdout. See rows to get the raw array.
    # @!method rows
    #   @return [Array<String>]
    #   @see Capture#rows
    # @!method row(row)
    #   @return [String]
    #   @see Capture#row
    # @!method width
    #   @see Capture#width
    #   @return [Integer]
    # @!method height
    #   @see Capture#height
    #   @return [Integer]
    # @!method cursor_x
    #   @see Capture#cursor_x
    #   @return [Integer]
    # @!method cursor_y
    #   @see Capture#cursor_y
    #   @return [Integer]
    # @!method cursor_visible?
    #   @see Capture#cursor_visible?
    #   @return [true,false]
    # @!method cursor_hidden?
    #   @see Capture#cursor_hidden?
    #   @return [true,false]
    def_delegators :capture, :print, :print_rows,
                   :rows, :row,
                   :width, :height,
                   :cursor_x, :cursor_y,
                   :cursor_visible?, :cursor_hidden?

    Assertions::METHODS.each do |matcher_name|
      define_method matcher_name do |*args, **kwargs|
        synchronize do
          capture.public_send(matcher_name, *args, **kwargs)
        end
      end
    end

    private

    def synchronize(seconds = max_wait_time)
      start_time = Time.now
      begin
        yield
      rescue MatchError => e
        raise e if (Time.now - start_time) >= seconds

        sleep 0.05
        retry
      end
    end
  end
end
