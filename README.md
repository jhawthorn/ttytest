TTYtest is an integration test framework for interactive tty applications. It's like [capybara](https://github.com/teamcapybara/capybara) for the terminal.

## Requirements

* tmux >= 1.8
* Ruby >= 2.1

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

Bug reports and pull requests are welcome on GitHub at https://github.com/jhawthorn/execjs-fastnode.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
