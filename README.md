TTYtest is an integration test framework for interactive console applications. It's like [capybara](https://github.com/teamcapybara/capybara) for the terminal.

It works by running commands inside a tmux session, capturing the pane, and comparing the content. The assertions will wait a specified amount of time (default 2 seconds) for the expected content to appear.

[![Build Status](https://travis-ci.org/jhawthorn/ttytest.svg?branch=master)](https://travis-ci.org/jhawthorn/ttytest)

## Requirements

* tmux >= 1.8
* Ruby >= 2.1

## Usage

``` ruby
@tty = TTYtest.driver.new_terminal(%{PS1='$ ' /bin/sh}, width: 80, height: 24)
@tty.assert_row(0, '$')
@tty.assert_cursor_position(x: 2, y: 0)

@tty.send_keys(%{echo "Hello, world"\n})

@tty.assert_row(0, '$ echo "Hello, world"')
@tty.assert_row(1, 'Hello, world')
@tty.assert_cursor_position(x: 2, y: 2)

p @tty.rows # => ["$ echo \"Hello, world\"", "Hello, world", "$", "", "", "", ...]
```

See also [fzy's integration test](https://github.com/jhawthorn/fzy/blob/master/test/integration/integration_test.rb) for a full example.

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
