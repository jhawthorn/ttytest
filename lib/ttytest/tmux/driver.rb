# frozen_string_literal: true

require 'open3'
require 'securerandom'

require 'ttytest/terminal'
require 'ttytest/tmux/session'

module TTYtest
  module Tmux
    # tmux driver
    class Driver
      COMMAND = 'tmux'
      SOCKET_NAME = 'ttytest'
      REQUIRED_TMUX_VERSION = '1.8'
      DEFAULT_CONFING_FILE_PATH = File.expand_path('tmux.conf', __dir__)
      SLEEP_INFINITY = 'read x < /dev/fd/1'

      class TmuxError < StandardError; end

      def initialize(
        debug: false,
        command: COMMAND,
        socket_name: SOCKET_NAME,
        config_file_path: DEFAULT_CONFING_FILE_PATH
      )
        @debug = debug
        @tmux_cmd = command
        @socket_name = socket_name
        @config_file_path = config_file_path
      end

      def new_terminal(cmd, width: 80, height: 24)
        cmd = "#{cmd}\n#{SLEEP_INFINITY}"

        session_name = "ttytest-#{SecureRandom.uuid}"
        tmux(*%W[-f #{@config_file_path} new-session -s #{session_name} -d -x #{width} -y #{height} #{cmd}])
        session = Session.new(self, session_name)
        Terminal.new(session)
      end

      def new_default_sh_terminal
        new_terminal(%(PS1='$ ' /bin/sh), width: 80, height: 24)
      end

      def new_sh_terminal(width: 80, height: 24)
        new_terminal(%(PS1='$ ' /bin/sh), width: width, height: height)
      end

      # @api private
      def tmux(*args)
        ensure_available
        puts "tmux(#{args.inspect[1...-1]})" if debug?

        stdout, stderr, status = Open3.capture3(@tmux_cmd, '-L', SOCKET_NAME, *args)
        raise TmuxError, "tmux(#{args.inspect[1...-1]}) failed\n#{stderr}" unless !status.nil? && status.success?

        stdout
      end

      def available?
        return false unless tmux_version

        @available ||= (Gem::Version.new(tmux_version) >= Gem::Version.new(REQUIRED_TMUX_VERSION))
      end

      private

      def debug?
        @debug
      end

      def ensure_available
        return if available?
        raise TmuxError, 'Running `tmux -V` to determine version failed. Is tmux installed?' unless tmux_version

        raise TmuxError, "tmux version #{tmux_version} does not meet requirement >= #{REQUIRED_TMUX_VERSION}"
      end

      def tmux_version
        @tmux_version ||= `#{@tmux_cmd} -V`[/tmux (\d+.\d+)/, 1]
      rescue Errno::ENOENT
        nil
      end
    end
  end
end
