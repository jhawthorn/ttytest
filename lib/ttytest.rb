# frozen_string_literal: true

require 'forwardable'
require 'ttytest/constants'
require 'ttytest/tmux/driver'
require 'ttytest/tmux/session'

# ttytest2 main module
module TTYtest
  class << self
    attr_accessor :driver, :default_max_wait_time

    attr_reader :terminal

    extend Forwardable
    # @!method new_terminal(command, width: 80, height: 24)
    #   Create a new terminal through the current driver.
    #   @param [String] command a valid shell command to run
    #   @param [Integer] width width of the new terminal
    #   @param [Integer] height height of the new terminal
    #   @return [Terminal] a new terminal running the specified command

    # @!method new_default_sh_terminal
    #   Create a new terminal using '/bin/sh' with width: 80 and height: 24.
    #   Useful for Unixes.

    # @!method new_sh_terminal(width: 80, height: 24)
    #   Create a new terminal using '/bin/sh' with ability to set width and height.
    #   Useful for Unixes.
    def_delegators :driver

    def new_terminal(cmd, width: 80, height: 24, max_wait_time: 2)
      @max_wait_time = max_wait_time
      driver.new_terminal(cmd, width: width, height: height)
    end

    def new_default_sh_terminal(max_wait_time: 2)
      @max_wait_time = max_wait_time
      driver.new_default_sh_terminal
    end

    def new_sh_terminal(width: 80, height: 24, max_wait_time: 2)
      @max_wait_time = max_wait_time
      driver.new_sh_terminal(width: width, height: height)
    end
  end

  # The error type raised when an assertion fails.
  class MatchError < StandardError; end

  self.driver = TTYtest::Tmux::Driver.new
  self.default_max_wait_time = 2
end
