# frozen_string_literal: true

require_relative "lib/sudachi-installer/version"

Gem::Specification.new do |spec|
  spec.name = "sudachi-installer"
  spec.version = SudachiInstaller::VERSION
  spec.authors = ["wtnabe"]
  spec.email = ["18510+wtnabe@users.noreply.github.com"]

  spec.summary = "download and store Sudachi jar and dict files"
  spec.homepage = "https://github.com/wtnabe/sudachi-installer-rb"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "octokit", "~> 6"
  spec.add_dependency "faraday-follow_redirects", "~> 0"
  spec.add_dependency "down", "~> 5"
  spec.add_dependency "xmlhasher", "~> 1"
  spec.add_dependency "dry-configurable", "~> 0"
  spec.add_dependency "rubyzip", "~> 2"
end
