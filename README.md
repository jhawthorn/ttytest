# ttytest2

ttytest2 is an acceptance test framework for interactive console applications. It's like [capybara](https://github.com/teamcapybara/capybara) for the terminal.

A drop-in replacement for https://github.com/jhawthorn/ttytest, because I had some features I needed for my own project.

It works by running commands inside a tmux session, capturing the pane, and comparing the content. The assertions will wait a specified amount of time (default 2 seconds) for the expected content to appear.

[![Gem Version](https://badge.fury.io/rb/ttytest2.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/ttytest2)

## Minimum Requirements

* tmux >= 1.8
* Ruby >= 3.2.3

## Usage

### Assertions

The main way to use TTYtest is through assertions. When called on a `TTYtest::Terminal`, each of these will be retried (for up to 2 seconds).

Available assertions:
* specify row matches expected text exactly: `assert_row(row_number, expected_text) `
* specify expected position of expected text: `assert_row_at(row_number, column_start_position, column_end_position, expected_text)`
* specify row contains expected text: `assert_row_like(row_number, expected_text)`
* specify row starts with expected text: `assert_row_starts_with(row_number, expected_text)`
* specify row ends with expected text: `assert_row_ends_with(row_number, expected_text)`
* specify the current cursor position matches expected: `assert_cursor_position(x: x, y: y)`
* specify the cursor is currently visible: `assert_cursor_visible`
* specify the cursor is currently hidden: `assert_cursor_hidden`
* specify the contents of the entire terminal window: `assert_contents(lines_of_terminal)`

### Sending output

You can send output to the terminal with the following calls.

* `send_keys(output)`
* `send_newline # equivalent to @tty.send_keys(%(\n))`
* `send_keys_one_at_a_time(output)`

### Example Canonical CLI/Shell

Most people should use send_keys, if you are writing or working with a noncanonical shell/CLI, you will probably know it. Most are canonical.

``` ruby
require 'ttytest'

@tty = TTYtest.new_terminal(%{PS1='$ ' /bin/sh}, width: 80, height: 24)
@tty.assert_row(0, '$')
@tty.assert_cursor_position(x: 2, y: 0)

@tty.send_keys(%{echo "Hello, world"\n})

@tty.assert_contents <<TTY
$ echo "Hello, world"
Hello, world
$
TTY
@tty.assert_cursor_position(x: 2, y: 2)

p @tty.rows # => ["$ echo \"Hello, world\"", "Hello, world", "$", "", "", "", ...]
```

### Example Noncanonical CLI/Shell

If you are working with a noncanonical shell, you need to use send_keys_one_at_a_time to have your shell/CLI process the input correctly.<br /><br />
Also useful if you need to send input one character at a time for whatever reason.<br /><br />
'Multi-character' characters like '\n' need to be sent with send-keys, though.<br /><br />

``` ruby
require 'ttytest'

@tty = TTYtest.new_terminal(%{PS1='$ ' /bin/noncanonical-sh}, width: 80, height: 24)
@tty.assert_row_starts_with(0, ENV['USER'])
@tty.assert_row_ends_with(0, '$')

@tty.send_keys_one_at_a_time('ls')
@tty.assert_row_ends_with(0, 'ls')
@tty.send_keys(%(\n)) # make sure to use send_keys for 'multi-character' characters like \n, \r, \t, etc.

@tty.send_keys_one_at_a_time('ps')
@tty.assert_row_ends_with(0, 'ps')
@tty.send_keys(TTYtest:NEWLINE) # can use constants instead

@tty.assert_row_starts_with(0, ENV['USER'])
@tty.assert_row_ends_with(0, '$')
@tty.send_newline # an alternative to the 2 above methods to send \n to the terminal
```

### Constants

There are some commonly used keys available as constants to make interacting with your shell/CLI easy. Most of them are self-evident, BACKSPACE is the same as hitting the backspace key on the keyboard.

``` ruby
  TTYtest::BACKSPACE
  TTYtest::TAB
  TTYtest::CTRLF
  TTYtest::CTRLC
  TTYtest::CTRLD
  TTYtest::ESCAPE

  TTYtest::UP_ARROW
  TTYtest::DOWN_ARROW
  TTYtest::RIGHT_ARROW
  TTYtest::LEFT_ARROW

  TTYtest::CLEAR # clear the screen
```

## Docker

Easy to use from Docker. Add this to your dockerfile to get started.

``` dockerfile
RUN apt update && \
  apt install gcc make ruby tmux -y && \
  gem install ttytest2

# add this if you have issues
# ENV RUBYOPT="-KU -E utf-8:utf-8"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a-eski/ttytest2.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
