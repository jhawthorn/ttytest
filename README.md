# ttytest2

ttytest2 is an acceptance test framework for interactive console applications. It's like [capybara](https://github.com/teamcapybara/capybara) for the terminal.

ttytest2 is a fork and a drop-in replacement for [ttytest](https://github.com/jhawthorn/ttytest), because I had some features I needed for my own project.

It works by running commands inside a tmux session, capturing the pane, and comparing the content to your assertions.

The assertions will wait a specified amount of time (configurable, default 2 seconds) for the expected content to appear.

[![Gem Version](https://badge.fury.io/rb/ttytest2.svg?icon=si%3Arubygems)](https://badge.fury.io/rb/ttytest2)

## Table of Contents

1. [Minimum Requirements](#minimum-requirements)
2. [Usage](#usage)
3. [Simple Example](#simple-example)
4. [Assertions](#assertions)
5. [Output](#output)
6. [Output Helpers](#output-helpers)
7. [Troubleshooting](#troubleshooting)
8. [Constants](#constants)
9. [Tips](#tips)
10. [Docker](#docker)
11. [Contributing](#contributing)
12. [License](#license)

## Minimum Requirements

* tmux >= 1.8
* Ruby >= 3.2.3

## Usage

* More documentation available at [ttytest2 docs](https://www.rubydoc.info/gems/ttytest2).
* There are more examples in the examples folder.

### Simple Example

``` ruby
require 'ttytest'

@tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 80, height: 7)
@tty.assert_row(0, '$')
@tty.assert_cursor_position(2, 0)

@tty.send_line('echo "Hello, world"'))

@tty.assert_contents <<~TTY
  $ echo "Hello, world"
  Hello, world
  $
TTY
@tty.assert_cursor_position(2, 2)

@tty.assert_contents_at(0, 0, '$ echo "Hello, world"')

@tty.assert_row_starts_with(0, '$ echo')
@tty.assert_row_ends_with(0, '"Hello, world"')
@tty.assert_row_starts_with(1, 'Hello')
@tty.assert_row_ends_with(1, ', world')

@tty.print_rows # prints out the contents of the terminal as an array:
# ["$ echo \"Hello, world\"", "Hello, world", "$", "", "", "", ""]

@tty.print # prints out the contents of the terminal:
# $ echo "Hello, world"
# Hello, world
# $
```

### Initializing

Call one of these methods to initialize an instance of ttytest2.

* `new_terminal(cmd, width, height)`: initialize new tmux terminal instance and run cmd.

* `new_default_sh_terminal()`: intialize new tmux terminal instance using sh, width of 80, height of 24.

* `new_sh_terminal(width, height)`: intialize new tmux terminal instance using sh and width and height parameters.

``` sh
require 'ttytest'

# these are all equivalent
@tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh))
@tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 80, height: 24)
@tty = TTYtest.new_default_sh_terminal
@tty = TTYtest.new_sh_terminal
@tty = TTYtest.new_sh_terminal(width: 80, height: 24)

# you can also use other shells, like bash
@tty = TTYtest.new_terminal('/bin/bash')
@tty = TTYtest.new_terminal('/bin/bash', width: 80, height: 24)
```

### Assertions

The main way to use TTYtest is through assertions.

Assertions will be retried for up to 2 seconds when called through TTYtest::Terminal.

Available assertions:

* `assert_row(row_number, expected_text)`

* `assert_row_at(row_number, column_start_position, column_end_position, expected_text)`

* `assert_row_like(row_number, expected_text)`

* `assert_row_starts_with(row_number, expected_text)`

* `assert_row_ends_with(row_number, expected_text)`

* `assert_row_regexp(row_number, regexp_str)`

* `assert_cursor_position(x: x, y: y)`

* `assert_cursor_visible`

* `assert_cursor_hidden`

* `assert_contents(lines_of_terminal)`

* `assert_contents_at(row_start, row_end, expected_text)`

### Output

You can send output to the terminal with the following calls.

Note: Most of the time send_line has the best ergonomics.

* `send_line(line)`: simulate typing in a command in the terminal and hitting enter!

* `send_line_then_sleep(line, sleep_time)`: simulate typing in a command in the terminal and hitting enter, then wait for sleep_time seconds.

* `send_lines(lines)`: for each line in lines, simulate sending the line and hitting enter.

* `send_lines_then_sleep(lines, sleep_time)`: for each line in lines, simulate sending the line and hitting enter. After sending all the lines, sleep for sleep_time.

* `send_line_then_sleep_and_repeat(lines, sleep_time)`: for each line in lines, simulate sending the line and hitting enter, then sleep before sending the next line.

* `send_keys(output)`: for canonical shells/CLI's (or multi-character keys for noncanonical shells/CLI's).

* `send_keys_one_at_a_time(output)`: for noncanonical shells/CLI's.

* `send_keys_exact(output)`: for sending tmux specific keys (any supported send-keys arguments like: DC for delete, Escape for ESC, etc.)

### Output Helpers

Helper functions to make sending output easier! They use the methods above under 'Sending Output' section under the hood.

* `send_newline` # simulate hitting enter, equivalent to @tty.send_keys(%(\n))
* `send_newlines(number_of_times)` # equivalent to calling send_newline number_of_times
* `send_enter` # alias for send_newline
* `send_enters(number_of_times)` # alias for send_newlines

* `send_backspace` # simulate hitting backspace, equivalent to @tty.send_keys(TTYtest::BACKSPACE)
* `send_backspaces(number_of_times)` # equivalent to calling send_backspace number_of_times

* `send_delete` # simulate hitting delete, equivalent to calling send_keys_exact(%(DC))
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

* `send_escape`
* `send_escapes`

### F keys?

Send F keys like F1, F2, etc. as shown below:

``` ruby
@tty = TTYtest.new_terminal(%{PS1='$ ' /bin/sh}, width: 80, height: 24)

@tty.send_keys_exact(%(F1))
@tty.send_keys_exact(%(F2))
# ...
@tty.send_keys_exact(%(F11))
@tty.send_keys_exact(%(F12))
```

### Configurables

Currently the only configuration for ttytest2 is max wait time.

Max wait time represents the amount of time in seconds that ttytest2 will keep retrying an assertion before failing.

You can configure max wait time as shown below.

``` ruby
@tty = TTYtest::new_terminal('')
@tty.max_wait_time = 1 # sets the max wait time to 1 second

@tty.assert_row(0, 'echo Hello, world') # this assertion would fail after 1 second
```

### Troubleshooting

You can use the method rows to get all rows of the terminal as an array, of use the method capture to get the contents of the terminal window. This can be useful when troubleshooting.

``` ruby
@tty = TTYtest.new_terminal(%(PS1='$ ' /bin/sh), width: 80, height: 7)
@tty.send_line('echo "Hello, world"'))

# you can use @tty.rows to access the entire pane, split by line into an array.
@tty.print_rows # prints out the contents of the terminal as an array:
# ["$ echo \"Hello, world\"", "Hello, world", "$", "", "", "", ""]

# if you want to programatically access the rows, you can do so using @tty.rows
p @tty.rows # is equivalent to above statement @tty.print_rows

# you can use @tty.capture to access the entire pane.
@tty.print # prints out the contents of the terminal:
# $ echo "Hello, world"
# Hello, world
# $

# if you want to programatically access the entire pane, you can do so using @tty.capture
p "\n#{@tty.capture}" # is equivalent to above statement @tty.print
```

### Constants

There are some commonly used keys available as constants to make interacting with your shell/CLI easy.

``` ruby
  TTYtest::CTRLA
  TTYtest::CTRLB
  TTYtest::CTRLC
  TTYtest::CTRLD
  TTYtest::CTRLF
  TTYtest::BELL # ring the terminal bell
  TTYtest::BACKSPACE
  TTYtest::TAB
  TTYtest::NEWLINE # \n
  TTYtest::ENTER # \n
  TTYtest::VERTICAL_TAB # \v
  TTYtest::SHIFT_ENTER # \v
  TTYtest::FORM_FEED # \f or New Page NP
  TTYtest::CTRLL
  TTYtest::CARRIAGE_RETURN # \r
  TTYtest::CTRLU
  TTYtest::CTRLW
  TTYtest::ESCAPE # 27 decimal or ^[ or /033
  TTYtest::CTRL_
  TTYtest::DELETE

  TTYtest::UP_ARROW
  TTYtest::DOWN_ARROW
  TTYtest::RIGHT_ARROW
  TTYtest::LEFT_ARROW

  TTYtest::HOME_KEY
  TTYtest::END_KEY

  TTYtest::CLEAR # clear the screen
```

## Tips

If you are using ttyest2 to test your CLI, using sh is easier than bash because you don't have to worry about user, current working directory, etc. as shown in the examples.

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
