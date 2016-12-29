require 'forwardable'
require 'ttytest/matchers'
require 'ttytest/capture'

module TTYtest
  class Terminal
    extend Forwardable

    def initialize(driver_terminal, max_wait_time: nil)
      @driver_terminal = driver_terminal
      @max_wait_time = max_wait_time
    end

    def max_wait_time
      @max_wait_time || TTYtest.default_max_wait_time
    end

    def_delegators :@driver_terminal, :send_keys, :send_raw, :capture
    def_delegators :capture, :rows, :row, :cursor_position, :width, :height, :cursor_visible?, :cursor_hidden?

    TTYtest::Matchers::METHODS.each do |matcher_name|
      define_method matcher_name do |*args|
        synchronize do
          capture.public_send(matcher_name, *args)
        end
      end
    end

    private

    def synchronize(seconds=max_wait_time)
      start_time = Time.now
      begin
        yield
      rescue MatchError => e
        raise e if (Time.now - start_time) >= seconds
        sleep 0.05
        retry
      end
    end
  end
end
