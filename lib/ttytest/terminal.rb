require 'forwardable'
require 'ttytest/matchers'
require 'ttytest/capture'

module TTYtest
  class Terminal
    include TTYtest::Matchers
    extend Forwardable

    def initialize(driver_terminal, synchronize: true)
      @driver_terminal = driver_terminal
      @synchronize = synchronize
    end

    def_delegators :@driver_terminal, :send_keys, :send_raw, :cursor_position
    def_delegators :capture, :rows, :row

    def capture
      Capture.new(@driver_terminal.capture)
    end

    def synchronize?
      @synchronize
    end
  end
end
