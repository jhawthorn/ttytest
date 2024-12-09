# ttytest2

ttytest2 is an acceptance test framework for interactive console applications. It's like [capybara](https://github.com/teamcapybara/capybara) for the terminal.

A drop-in replacement for [ttytest](https://github.com/jhawthorn/ttytest), because I had some features I needed for my own project.

It works by running commands inside a tmux session, capturing the pane, and comparing the content.

The assertions will wait a specified amount of time (default 2 seconds) for the expected content to appear.

[![Gem Version](https://badge.fury.io/rb/ttytest2.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/ttytest2)

## Table of Contents

1. [Minimum Requirements](#minimum-requirements)
2. [Usage](#usage)
3. [Example for Canonical CLI or Shell](#example-for-canonical-cli-or-shell)
4. [Example for Noncanonical CLI or Shell](#example-for-noncanonical-cli-or-shell)
5. [Assertions](#assertions)
6. [Output](#output)
7. [Output Helpers](#output-helpers)
8. [Troubleshooting](#troubleshooting)
9. [Constants](#constants)
10. [Tips](#tips)
11. [Docker](#docker)
12. [Contributing](#contributing)
13. [License](#license)

## Minimum Requirements

* tmux >= 1.8
* Ruby >= 3.2.3

## Usage

More documentation available at [ttytest2 docs](https://www.rubydoc.info/gems/ttytest2).

There are more examples in the examples folder.

### Example for Canonical CLI or Shell

Most people should use send_keys, if you are writing or working with a noncanonical shell/CLI, you will probably know it! Most shell/CLI applications are canonical.

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

@tty.assert_contents_at(0, 0, '$ echo "Hello, world"')

@tty.assert_row_starts_with(0, '$ echo')
@tty.assert_row_ends_with(0, '"Hello, world"')
@tty.assert_row_starts_with(1, 'Hello')
@tty.assert_row_ends_with(1, ', world')

@tty.print_rows # => ["$ echo \"Hello, world\"", "Hello, world", "$", "", "", "", ...]

@tty.print # prints out the contents of the terminal
```

### Example for Noncanonical CLI or Shell

If you are working with a noncanonical shell, you need to use send_keys_one_at_a_time to have your shell/CLI process the input correctly.

Also useful if you need to send input one character at a time for whatever reason.

'Multi-character' characters like '\n' need to be sent with send-keys, though.

``` ruby
require 'ttytest'

@tty = TTYtest.new_terminal(%{PS1='$ ' /bin/noncanonical-sh}, width: 80, height: 24)
@tty.assert_row_starts_with(0, ENV['USER'])
@tty.assert_row_ends_with(0, '$')

@tty.send_keys_one_at_a_time('ls')
@tty.assert_row_ends_with(0, 'ls')
@tty.send_newline # builtins for common outputs line newline

@tty.send_keys_one_at_a_time('ps')
@tty.assert_row_ends_with(1, 'ps')
@tty.send_keys(TTYtest:NEWLINE) # can use constants instead

@tty.assert_row_starts_with(2, ENV['USER'])
@tty.assert_row_ends_with(2, '$')
@tty.send_newline

puts "\n#{@tty.capture}" # prints out the contents of the terminal, equivalent to @tty.print
```

### Assertions

The main way to use TTYtest is through assertions. When called on a `TTYtest::Terminal`, each of these will be retried (for up to 2 seconds).

Available assertions:

* `assert_row(row_number, expected_text)`
* `assert_row_at(row_number, column_start_position, column_end_position, expected_text)`
* `assert_row_like(row_number, expected_text)`
* `assert_row_starts_with(row_number, expected_text)`
* `assert_row_ends_with(row_number, expected_text)`
* `assert_cursor_position(x: x, y: y)`
* `assert_cursor_visible`
* `assert_cursor_hidden`
* `assert_contents(lines_of_terminal)`
* `assert_contents_at(row_start, row_end, expected_text)`

### Output

You can send output to the terminal with the following calls.

* `send_keys(output) # for canonical shells/CLI's (or multi-character keys for noncanonical shells/CLI's)`
* `send_keys_one_at_a_time(output) # for noncanonical shells/CLI's`
* `send_keys_exact(output) # for sending tmux specific keys (DC for delete, Escape for ESC, etc.)`

### Output Helpers

Helper functions to make sending output easier! They use the methods above under 'Sending Output' section under the hood.

* `send_newline` # equivalent to @tty.send_keys(%(\n))
* `send_newlines(number_of_times)` # equivalent to calling send_newline number_of_times
* `send_backspace` # equivalent to @tty.send_keys(TTYtest::BACKSPACE)
* `send_backspaces(number_of_times)` # equivalent to calling send_backspace number_of_times
* `send_delete` # equivalent to calling send_keys_exact(%(DC))
* `send_deletes` # equivalent to calling send_delete number_of_times
* `send_right_arrow`
* `send_right_arrows(number_of_times)`
* `send_left_arrow`
* `send_left_arrows(number_of_times)`
* `send_up_arrow`
* `send_up_arrows(number_of_times)`
* `send_down_arrow`
* `send_down_arrows(number_of_times)`
* `send_home` # simulate pressing the Home key
* `send_end` # simulate pressing the End key
* `send_clear` # clear the screen by sending clear ascii code

### Configurables

You can configure the max wait time (in seconds) for ttytest2 to wait before failing an assertion.

For the max wait time, ttytest2 keeps retrying the assertions.

``` ruby
@tty = TTYtest::new_terminal('')
@tty.max_wait_time = 1 # sets the max wait time to 1 second

@tty.assert_row(0, 'echo Hello, world') # this assertion would fail after 1 second
```

### Troubleshooting

You can use the method rows to get all rows of the terminal as an array, of use the method capture to get the contents of the terminal window. This can be useful when troubleshooting.

``` ruby
@tty = TTYtest::new_terminal('')

# you can use @tty.rows to access the entire pane, split by line into an array.
p @tty.rows # prints out the contents of the terminal as a array.
@tty.print_rows # equivalent to above, just for ease of use.

# you can use @tty.capture to access the entire pane.
p "\n#{@tty.capture}" # prints out the contents of the terminal
@tty.print # equivalent to above, just for ease of use.
```

### Constants

There are some commonly used keys available as constants to make interacting with your shell/CLI easy.

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

### Tips

If you are using ttyest2 to test your CLI, using sh is easier than bash because you don't have to worry about user, current working directory, etc. as shown in the examples above.

If you are using ttytest2 to test your shell, using assertions like assert_row_like, assert_row_starts_with, and assert_row_ends_with are going to be extremely helpful, especially if trying to test your shell in different environments or using a docker container.

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

Bug reports and pull requests are welcome on GitHub at [ttytest2](https://github.com/a-eski/ttytest2).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
