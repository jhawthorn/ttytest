require 'forwardable'
require 'ttytest/tmux/driver'
require 'ttytest/tmux/session'

module TTYtest
  class << self
    attr_accessor :driver, :default_max_wait_time

    extend Forwardable
    # @!method new_terminal(command, width: 80, height: 24)
    #   Create a new terminal through the current driver.
    #   @param [String] command a valid shell command to run
    #   @param [Integer] width width of the new terminal
    #   @param [Integer] height height of the new terminal
    #   @return [Terminal] a new terminal running the specified command
    def_delegators :driver, :new_terminal
  end

  class MatchError < StandardError; end

  self.driver = TTYtest::Tmux::Driver.new
  self.default_max_wait_time = 2
end
