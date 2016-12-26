require 'ttytest/tmux/driver'
require 'ttytest/tmux/session'

module TTYtest
  class << self
    attr_accessor :driver
  end

  self.driver = TTYtest::Tmux::Driver.new
end
