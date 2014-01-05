# Bundler::Reorganizer

> Automated reorganization for all your Gemfiles.

One simple command turns your **unwieldy** Gemfile from this:
```ruby
gem "utils", :group => :development
gem "more-tools", :group => :development
gem "testsuite-runner", :group => [:development, :test]
```

Into this!
```ruby
group :development do
  gem "utils"
  gem "more-tools"
end

group :development, :test do
  gem "testsuite-runner"
end
```

## Usage

```bash
$ bundler-reorganizer path/to/Gemfile
```

#### (optional) `--output path/to/reorganized/Gemfile`

Controls the location of reorganized Gemfile.

aliased to `-o`

example:
```bash
$ bundler-reorganizer path/to/original/Gemfile --output path/to/reorganized/Gemfile
```

## Installation

```bash
$ gem install bundler-reorganizer
```

## Contributing

Patches are always welcome and thank you to all [project contributors](https://github.com/wireframe/bundler-reorganizer/graphs/contributors)!

Interested in contributing?  Review the project [contribution guidelines](CONTRIBUTING.md) and get started!
