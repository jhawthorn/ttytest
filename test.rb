# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib/', __FILE__)
require 'ttytest'

session = TTYtest.driver.new_session
sleep 1
session.send_raw('echo "Hello, world"')
session.send_keys("Enter")
sleep 1
puts session.capture
p session.row(0)
p session.row(1)
p session.cursor_position
