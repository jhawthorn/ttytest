# frozen_string_literal: true

require 'test_helper'

module TTYtest
  class TmuxDriverTest < Minitest::Test
    # Fake Tmux Command Test Helper: Fake a tmux command which just outputs the passed in version
    def with_fake_tmux_command(version)
      file = Tempfile.new('ttytest_fake_tmux')
      begin
        file.chmod(0o700)
        file.puts <<~RUBY
          echo 'tmux #{version}'
        RUBY
        file.close
        yield file.path
      ensure
        file.close
        file.unlink # deletes the temp file
      end
    end

    def test_driver_available
      # Using actual tmux
      @driver = TTYtest::Tmux::Driver.new
      assert @driver.available?
    end

    def test_availability_valid_version
      with_fake_tmux_command('1.8') do |cmd|
        @driver = TTYtest::Tmux::Driver.new(command: cmd)
        assert @driver.available?
      end

      with_fake_tmux_command('2.0') do |cmd|
        @driver = TTYtest::Tmux::Driver.new(command: cmd)
        assert @driver.available?
      end
    end

    def test_availability_invalid_version
      with_fake_tmux_command('1.7') do |cmd|
        @driver = TTYtest::Tmux::Driver.new(command: cmd)
        assert !@driver.available?
        assert_raises TTYtest::Tmux::Driver::TmuxError do
          @driver.new_terminal('')
        end
      end
    end

    def test_availability_tmux_command_not_found
      @driver = TTYtest::Tmux::Driver.new(command: 'tmux_command_not_found')
      assert !@driver.available?
      assert_raises TTYtest::Tmux::Driver::TmuxError do
        @driver.new_terminal('')
      end
    end

    def test_syntax_error
      @tty = TTYtest.new_terminal('fi')
      ex = assert_raises TTYtest::Tmux::Driver::TmuxError do
        # We use an assertion that will never match in order to perform
        # captures until the command errors
        @tty.assert_contents 'this is never found'
      end
      assert_includes ex.message, "Tmux pane has died\nCommand exited with status:"
    end
  end
end
