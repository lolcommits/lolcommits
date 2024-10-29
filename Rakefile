# frozen_string_literal: true

# tests
require "minitest/test_task"
Minitest::TestTask.create(:test) do |t|
  t.warning = false
end

# docs
require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb', 'bin/**/*')
  rdoc.rdoc_dir = 'doc'
end

# gem build and release
require "bundler"
Bundler::GemHelper.install_tasks

task default: :test
