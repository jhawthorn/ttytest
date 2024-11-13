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
    #   Simulate typing keys into the terminal
    #   @param [String] keys keys to send to the terminal
    # @!method capture
    #   Capture the current state of the terminal
    #   @return [Capture] instantaneous state of the terminal when called
    def_delegators :@driver_terminal, :send_keys, :capture

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
