# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "sudachi-installer"

# require "minitest/skip_dsl" # avoid circular requirement
require "minitest/reporters"
require "minitest-power_assert"
require "webmock/minitest"
require "vcr"
require "minitest/autorun"

VCR.configure do |c|
  c.cassette_library_dir = File.join(__dir__, "/fixtures/cassettes")
  c.hook_into :webmock
  c.default_cassette_options = {erb: true}
end

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
