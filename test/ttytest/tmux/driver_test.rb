
require "test_helper"

module TTYtest
  class TmuxDriverTest < Minitest::Test
    def test_availability
      # Using actual tmux
      @driver = TTYtest::Tmux::Driver.new
      assert @driver.available?

      # Using fake tmux which just prints 1.8
      with_fake_tmux_command('1.8') do |cmd|
        @driver = TTYtest::Tmux::Driver.new(command: cmd)
        assert @driver.available?
      end

      with_fake_tmux_command('2.0') do |cmd|
        @driver = TTYtest::Tmux::Driver.new(command: cmd)
        assert @driver.available?
      end

      with_fake_tmux_command('1.7') do |cmd|
        @driver = TTYtest::Tmux::Driver.new(command: cmd)
        assert !@driver.available?
        assert_raises TTYtest::Tmux::Driver::TmuxError, "tmux version 1.7 does not meet requirement >= 1.8" do
          @driver.new_terminal('')
        end
      end

      @driver = TTYtest::Tmux::Driver.new(command: "tmux_command_not_found")
      assert !@driver.available?
      assert_raises TTYtest::Tmux::Driver::TmuxError, "tmux version 1.7 does not meet requirement >= 1.8" do
        @driver.new_terminal('')
      end
    end

    def with_fake_tmux_command(version)
      file = Tempfile.new('ttytest_fake_tmux')
      begin
        file.chmod(0700)
        file.puts <<RUBY
echo 'tmux #{version}'
RUBY
        file.close
        yield file.path
      ensure
        file.close
        file.unlink   # deletes the temp file
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
