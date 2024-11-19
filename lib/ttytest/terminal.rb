# frozen_string_literal: true

require 'forwardable'
require 'ttytest/matchers'
require 'ttytest/capture'

module TTYtest
  # @attr [Integer] max_wait_time the maximum amount of time (in seconds) to retry assertions before failing.
  class Terminal
    extend Forwardable

    attr_accessor :max_wait_time

    # @api private
    # @see TTYtest.new_terminal
    def initialize(driver_terminal, max_wait_time: nil)
      @driver_terminal = driver_terminal
      @max_wait_time = max_wait_time || TTYtest.default_max_wait_time
    end

    # @!method send_keys(*keys)
    #   Simulate typing keys into the terminal. For canonical cli's/shells which read line by line.
    #   @param [String] keys keys to send to the terminal
    # @!method send_keys_one_at_a_time(keys)
    #   Simulate typing keys into the terminal. For noncanonical cli's/shells which read character by character.
    #   @param [String] keys keys to send to the terminal
    # @!method send_newline
    #   Simulate typing enter by sending newline character to the terminal.
    # @!method send_delete
    #   Simulate typing the delete key in the terminal.
    # @!method send_backspace
    #   Simulate typing the backspace key in the terminal.
    # @!method send_keys_exact
    #   Send tmux send-keys command to the terminal, such as DC or Enter, to simulate pressing that key in the terminal.
    # @!method capture
    #   Capture the current state of the terminal
    #   @return [Capture] instantaneous state of the terminal when called
    def_delegators :@driver_terminal,
                   :send_keys, :send_keys_one_at_a_time, :send_newline, :send_delete, :send_backspace, :send_keys_exact,
                   :capture

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
    def_delegators :capture, :rows, :row, :width, :height, :cursor_x, :cursor_y, :cursor_visible?, :cursor_hidden?

    TTYtest::Matchers::METHODS.each do |matcher_name|
      define_method matcher_name do |*args|
        synchronize do
          capture.public_send(matcher_name, *args)
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
