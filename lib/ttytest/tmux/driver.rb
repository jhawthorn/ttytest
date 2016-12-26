# frozen_string_literal: true

require 'open3'
require 'securerandom'

require 'ttytest/tmux/session'

module TTYtest
  module Tmux
    class Driver
      COMMAND = 'tmux'
      SOCKET_NAME = 'ttytest'

      class TmuxError < StandardError; end

      def initialize(debug: false, command: COMMAND, socket_name: SOCKET_NAME)
        @debug = debug
        @tmux_cmd = command
        @socket_name = socket_name
      end

      def new_session(width: 80, height: 24)
        session_name = "ttytest-#{SecureRandom.uuid}"
        cmd = %(PS1='$ ' /bin/sh)
        tmux(*%W[new-session -s #{session_name} -d -x #{width} -y #{height} #{cmd}])
        Session.new(self, session_name)
      end

      def tmux(*args)
        puts "tmux(#{args.inspect[1...-1]})" if debug?

        stdout, stderr, status = Open3.capture3(COMMAND, '-L', SOCKET_NAME, *args)
        raise TmuxError, "tmux(#{args.join}) failed\n#{stderr}" unless status.success?
        stdout
      end

      def debug?
        @debug
      end
    end
  end
end
