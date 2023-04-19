# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "yard"

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

YARD::Rake::YardocTask.new do |t|
  t.files = ["lib/**/*.rb", "spec/**/*.rb"]
  t.stats_options = ["--list-undoc"]
end

require "standard/rake"

desc "tmp:clear"
task "tmp:clear" do
  Dir.glob(File.join(__dir__, "/tmp/*")).each { |f|
    FileUtils.rm_rf(f)
  }
end

task default: %i[spec standard]
