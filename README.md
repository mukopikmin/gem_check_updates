# Gem Check Updates

[![Gem Version](https://badge.fury.io/rb/gem_check_updates.svg)](https://badge.fury.io/rb/gem_check_updates)
[![Build Status](https://travis-ci.org/mukopikmin/gem_check_updates.svg?branch=master)](https://travis-ci.org/mukopikmin/gem_check_updates)
[![Maintainability](https://api.codeclimate.com/v1/badges/45a740c1633d4de67e70/maintainability)](https://codeclimate.com/github/mukopikmin/gem_check_updates/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/45a740c1633d4de67e70/test_coverage)](https://codeclimate.com/github/mukopikmin/gem_check_updates/test_coverage)

Update the version of gems in Gemfile.
This gem is inspired by [tjunnone/npm-check-updates](https://github.com/tjunnone/npm-check-updates).

## Installation

    $ gem install gem_check_updates

## Usage

See references with option `-h` or `--help`.

    $ gem-check-updates -h

    Usage: run [options]
    -f, --file Gemfile               Path to Gemfile (default: ./Gemfile)
    -a, --apply                      Apply updates (default: false)
        --major                      Update major version (default: true)
        --minor                      Update minor version (default: false)
        --patch                      Update patch version (default: false)
    -i, --include-beta               Check updates of beta release, including alpha or release candidate (Default: false)

Also you can run command as follows.

    $ gcu

### Examples

Check updates for the specified Gemfile in current working directory.

    $ gcm -f path/to/Gemfile

    ....

    Checking major updates are completed.

    You can update following newer gems.
    If you want to apply these updates, run command with option --apply.
    Running with --apply option will overwrite your Gemfile.

        rails                       "~> 5.1.0"   →    "~> 5.2.1"
        puma                        "~> 3.10"    →    "~> 3.9.1"
        byebug                      "~> 10.0.0"  →    "~> 9.1.0"
        rspec-rails                 "~> 3.7.2"   →    "~> 3.8.0"

Check and overwrite existing Gemfile.

    $ gcm -f path/to/Gemfile --apply

    ....

    Checking major updates are completed.

    Following gems have been updated!

        rails                       "~> 5.1.0"   →    "~> 5.2.1"
        puma                        "~> 3.10"    →    "~> 3.9.1"
        byebug                      "~> 10.0.0"  →    "~> 9.1.0"
        rspec-rails                 "~> 3.7.2"   →    "~> 3.8.0"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mukopikmin/gem_check_updates.
