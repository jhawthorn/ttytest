# frozen_string_literal: true

require 'forwardable'
require 'ttytest/constants'
require 'ttytest/tmux/driver'
require 'ttytest/tmux/session'

# ttytest2 main module
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

    # @!method new_default_sh_terminal
    #   Create a new terminal using '/bin/sh' with width: 80 and height: 24.
    #   Useful for Unixes.

    # @!method new_sh_terminal(width: 80, height: 24)
    #   Create a new terminal using '/bin/sh' with ability to set width and height.
    #   Useful for Unixes.
    def_delegators :driver, :new_terminal, :new_default_sh_terminal, :new_sh_terminal
  end

  class MatchError < StandardError; end

  self.driver = TTYtest::Tmux::Driver.new
  self.default_max_wait_time = 2
end
