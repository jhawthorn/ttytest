require 'forwardable'
require 'ttytest/matchers'

module TTYtest
  class Terminal
    include TTYtest::Matchers
    extend Forwardable

    def initialize(driver_terminal, synchronize: true)
      @driver_terminal = driver_terminal
      @synchronize = synchronize
    end

    def_delegators :@driver_terminal, :capture, :send_keys, :send_raw, :cursor_position

    def rows
      (capture+"\nEND").split("\n")[0...-1].map do |row|
        row || ""
      end
    end

    def row(row)
      rows[row]
    end

    def synchronize?
      @synchronize
    end
  end
end
