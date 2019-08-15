TTYtest is an acceptance test framework for interactive console applications. It's like [capybara](https://github.com/teamcapybara/capybara) for the terminal.

It works by running commands inside a tmux session, capturing the pane, and comparing the content. The assertions will wait a specified amount of time (default 2 seconds) for the expected content to appear.

[![Gem Version](https://badge.fury.io/rb/ttytest.svg)](https://rubygems.org/gems/ttytest)

## Requirements

* tmux >= 1.8
* Ruby >= 2.1

## Usage

### Example

``` ruby
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

See also [fzy's integration test](https://github.com/jhawthorn/fzy/blob/master/test/integration/integration_test.rb) for a full example.

### Assertions

The main way to use TTYtest is through assertions. When called on a `TTYtest::Terminal`, each of these will be retried (for up to 2 seconds by default).

Available assertions:
* `assert_row(row_number, expected_text)`
* `assert_cursor_position(x: x, y: y)`
* `assert_cursor_visible`
* `assert_cursor_hidden`
* `assert_contents(lines_of_terminal)`

## TravisCI

TTYtest can run on [TravisCI](https://travis-ci.org/), but the version of tmux made available with their default ubuntu 12.04 environment is too old. However the TravisCI ubuntu 14.04 "trusty" image provides tmux 1.8, which works great.

Ensure the following is in your `.travis.yml` (see [this project's .travis.yml](./.travis.yml) for an example)

``` yaml
dist: trusty
addons:
  apt:
    packages:
    - tmux
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jhawthorn/ttytest.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
