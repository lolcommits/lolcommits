# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rdoc/task"

Minitest::TestTask.create(:test) do |t|
  t.warning = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb", "bin/**/*")
  rdoc.rdoc_dir = "doc"
end

task default: :test
