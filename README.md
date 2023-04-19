# SudachiInstaller

A helper gem to downloading and extracting Sudachi executable and dictionary files.

Use with [rudachi-rb](https://github.com/songcastle/rudachi-rb) :)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add sudachi-installer

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install sudachi-installer

## Usage

```ruby
require "sudachi-installer/releases"
require "sudachi-installer/dicts"
require "rudachi-rb"

SudachiInstaller.configure do |c|
  c.jar_dir = "/path/to/jar_dir"
  c.dict_dir = "/path/to/dict_dir"
end

releases = SudachiInstaller::Releases.new
# releases.minimum_list
releases.download("v0.7.1")

dicts = SudachiInstaller::Dicts.new
# dicts.revisions(:dict)
dicts.download(:dict, "20230110", "small")

resolver = SudachiInstaller::Resolver.new

Rudachi.configure do |c|
  config.jar_path = resolver.jar_path("0.7.1")
end

Rudachi::Option.configure do |c|
  c.s = {"systemDict": resolver.dict_path(revision: "20230110", edition: "small")
  c.a = true
  c.m = "C"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wtnabe/sudachi-installer.
