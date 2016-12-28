TTYtest is an integration test framework for interactive tty applications. It's like [capybara](https://github.com/teamcapybara/capybara) for the terminal.

[![Build Status](https://travis-ci.org/jhawthorn/ttytest.svg?branch=master)](https://travis-ci.org/jhawthorn/ttytest)

## Requirements

* tmux >= 1.8
* Ruby >= 2.1

## Usage

``` ruby
class TTYtestTest < Minitest::Test
  def test_shell_hello_world
    @tty = TTYtest.driver.new_terminal(%{PS1='$ ' /bin/sh})
    @tty.assert_row(0, '$')

    @tty.send_raw('echo "Hello, world"', "\n")

    @tty.assert_row(0, '$ echo "Hello, world"')
    @tty.assert_row(1, 'Hello, world')
    @tty.assert_cursor_position(2, 2)
  end
end
```

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
