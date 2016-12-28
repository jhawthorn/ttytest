# frozen_string_literal: true

require 'open3'
require 'securerandom'

require 'ttytest/terminal'
require 'ttytest/tmux/session'

module TTYtest
  module Tmux
    class Driver
      COMMAND = 'tmux'
      SOCKET_NAME = 'ttytest'
      REQUIRED_TMUX_VERSION = '1.8'

      class TmuxError < StandardError; end

      def initialize(debug: false, command: COMMAND, socket_name: SOCKET_NAME)
        @debug = debug
        @tmux_cmd = command
        @socket_name = socket_name
      end

      def new_terminal(cmd, width: 80, height: 24)
        session_name = "ttytest-#{SecureRandom.uuid}"
        tmux(*%W[new-session -s #{session_name} -d -x #{width} -y #{height} #{cmd}])
        session = Session.new(self, session_name)
        Terminal.new(session)
      end

      def tmux(*args)
        ensure_available
        puts "tmux(#{args.inspect[1...-1]})" if debug?

        stdout, stderr, status = Open3.capture3(COMMAND, '-L', SOCKET_NAME, *args)
        raise TmuxError, "tmux(#{args.join}) failed\n#{stderr}" unless status.success?
        stdout
      end

      def available?
        @available ||= (Gem::Version.new(tmux_version) >= Gem::Version.new(REQUIRED_TMUX_VERSION))
      end

      def debug?
        @debug
      end

      private

      def ensure_available
        if !available?
          if !tmux_version
            raise TmuxError, "tmux doesn't seem to be unstalled" unless available?
          else
            raise TmuxError, "tmux version #{tmux_version} does not meet requirement >= #{REQUIRED_TMUX_VERSION}" unless available?
          end
        end
      end

      def tmux_version
        @tmux_version ||= `tmux -V`[/tmux (\d+.\d+)/, 1]
      rescue Errno::ENOENT
        nil
      end
    end
  end
end
