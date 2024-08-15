# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in sudachi-installer.gemspec
gemspec

group :development do
  gem "rake", "~> 13.0"
  gem "standard", "~> 1.37"
  gem "rubocop", "~> 1.62"
  gem "solargraph", "> 0.38"
  gem "yard", ">= 0.9.30"
end

group :development, :test do
  gem "minitest", "~> 5.0"
  gem "minitest-reporters", "~> 1"
  gem "minitest-power_assert"
  gem "minitest-skip"
  gem "vcr", "~> 6"
  gem "webmock", "~> 3"
end
