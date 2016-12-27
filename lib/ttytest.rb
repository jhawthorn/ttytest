require 'ttytest/tmux/driver'
require 'ttytest/tmux/session'

module TTYtest
  class << self
    attr_accessor :driver
    attr_accessor :default_max_wait_time
  end

  class MatchError < StandardError; end

  self.driver = TTYtest::Tmux::Driver.new
  self.default_max_wait_time = 2
end
