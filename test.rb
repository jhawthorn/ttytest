# frozen_string_literal: true

require 'open3'
require 'securerandom'

class TmuxDriver
  TMUX_CMD = 'tmux'
  SOCKET_NAME = 'ttytest'

  def initialize(debug: false)
    @debug = debug
  end

  class TmuxError < StandardError
  end

  class Session < Struct.new(:driver, :name)
    def capture
      driver.tmux(*%W[capture-pane -t #{name} -p])
    end

    def send_keys(*keys)
      driver.tmux(*%W[send-keys -t #{name}], *keys)
    end

    def send_raw(*keys)
      driver.tmux(*%W[send-keys -t #{name} -l], *keys)
    end

    def rows(first, last)
      capture.split("\n")[first..last]
    end

    def row(row)
      rows(row, row)
    end

    def cursor_position
      str = driver.tmux(*%W[display-message -t #{name} -p #\{cursor_x},#\{cursor_y}])
      str.split(',').map(&:to_i)
    end
  end

  def new_session(width: 80, height: 24)
    session_name = "ttytest-#{SecureRandom.uuid}"
    cmd = %(PS1='$ ' /bin/sh)
    tmux(*%W[new-session -s #{session_name} -d -x #{width} -y #{height} #{cmd}])
    Session.new(self, session_name)
  end

  def tmux(*args)
    puts "tmux(#{args.inspect[1...-1]})" if debug?

    stdout, stderr, status = Open3.capture3(TMUX_CMD, '-L', SOCKET_NAME, *args)
    raise TmuxError, "tmux(#{args.join}) failed\n#{stderr}" unless status.success?
    stdout
  end

  def debug?
    @debug
  end
end

driver = TmuxDriver.new(debug: true)
session = driver.new_session
sleep 1
session.send_raw('echo "Hello, world"')
session.send_keys("Enter")
sleep 1
puts session.capture
p session.row(0)
p session.row(1)
p session.cursor_position
