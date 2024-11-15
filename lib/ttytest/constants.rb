# frozen_string_literal: true

# some constants that can be used with send_keys, just to help out people creating tests
module TTYtest
  BACKSPACE = 127.chr
  DELETE = '^[[3~'
  TAB = 9.chr
  CTRLF = 6.chr
  CTRLC = 3.chr
  CTRLD = '\004'
  ESCAPE = 27.chr

  UP_ARROW = '^[[A'
  DOWN_ARROW = '^[[B'
  RIGHT_ARROW = '^[[C'
  LEFT_ARROW = '^[[D'

  CLEAR = 'clear'
end
