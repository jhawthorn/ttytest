require 'forwardable'
require 'ttytest/matchers'
require 'ttytest/capture'

module TTYtest
  class Terminal
    extend Forwardable

    def initialize(driver_terminal, synchronize: true)
      @driver_terminal = driver_terminal
      @synchronize = synchronize
    end

    def_delegators :@driver_terminal, :send_keys, :send_raw, :capture
    def_delegators :capture, :rows, :row, :cursor_position

    def synchronize?
      @synchronize
    end

    def synchronize(seconds=TTYtest.default_max_wait_time)
      start_time = Time.now
      begin
        yield
      rescue MatchError => e
        raise e unless synchronize?
        raise e if (Time.now - start_time) >= seconds
        sleep 0.05
        retry
      end
    end

    TTYtest::Matchers::METHODS.each do |matcher_name|
      define_method matcher_name do |*args|
        synchronize do
          capture.public_send(matcher_name, *args)
        end
      end
    end
  end
end
