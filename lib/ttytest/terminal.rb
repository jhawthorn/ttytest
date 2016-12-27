require 'forwardable'
require 'ttytest/matchers'

module TTYtest
  class Terminal
    include TTYtest::Matchers
    extend Forwardable

    def initialize(driver_terminal)
      @driver_terminal = driver_terminal
    end

    def_delegators :@driver_terminal, :capture, :send_keys, :send_raw, :cursor_position

    def rows(first, last)
      capture.split("\n")[first..last]
    end

    def row(row)
      capture.split("\n")[row]
    end
  end
end
