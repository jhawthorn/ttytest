# frozen_string_literal: true

# some constants that can be used with send_keys, just to help out people creating tests
module TTYtest
  CTRLA = 1.chr
  CTRLB = 2.chr
  CTRLC = 3.chr
  CTRLD = 4.chr
  CTRLF = 6.chr
  BELL = 7.chr
  BACKSPACE = 8.chr
  TAB = 9.chr # \t
  NEWLINE = 10.chr # \n
  VERTICAL_TAB = 11.chr # \v
  FORM_FEED = 12.chr # \f
  CARRIAGE_RETURN = 13.chr # \r
  CTRLU = 21.chr
  CTRLW = 23.chr
  ESCAPE = 27.chr # ^[ or /033 or /e
  DELETE = 127.chr

  UP_ARROW = "#{ESCAPE}[A".freeze
  DOWN_ARROW = "#{ESCAPE}[B".freeze
  RIGHT_ARROW = "#{ESCAPE}[C".freeze
  LEFT_ARROW = "#{ESCAPE}[D".freeze

  HOME_KEY = "#{ESCAPE}[H".freeze
  END_KEY = "#{ESCAPE}[F".freeze

  CLEAR = "#{ESCAPE}[2J".freeze
end
