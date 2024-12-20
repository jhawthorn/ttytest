# frozen_string_literal: true

# some constants that can be used with send_keys, just to help out people creating tests
module TTYtest
  BACKSPACE = 127.chr
  TAB = 9.chr
  CTRLF = 6.chr
  CTRLC = 3.chr
  CTRLD = '\004'
  ESCAPE = 27.chr

  UP_ARROW = "#{ESCAPE}[A".freeze
  DOWN_ARROW = "#{ESCAPE}[B".freeze
  RIGHT_ARROW = "#{ESCAPE}[C".freeze
  LEFT_ARROW = "#{ESCAPE}[D".freeze

  HOME_KEY = "#{ESCAPE}[H".freeze
  END_KEY = "#{ESCAPE}[F".freeze

  CLEAR = "#{ESCAPE}[2J".freeze
end
