# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib/', __FILE__)
require 'ttytest'

session = TTYtest.driver.new_terminal(%{PS1='$ ' /bin/sh})
session.assert_row(0, '$')
session.send_raw('echo "Hello, world"')
session.send_keys("Enter")
session.assert_row(1, 'Hello, world')
puts session.capture
p session.row(0)
p session.row(1)
p session.cursor_position
