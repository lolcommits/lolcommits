# frozen_string_literal: true

require 'bundler'
require 'rake/clean'
require 'rake/testtask'
require 'cucumber'
require 'cucumber/rake/task'
require 'rdoc/task'
require 'rubocop/rake_task'

# docs
Rake::RDocTask.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb', 'bin/**/*')
  rdoc.rdoc_dir = 'doc'
end

# gem building
Bundler::GemHelper.install_tasks
task :ensure_executable_permissions do
  # Reset all permissions.
  system 'bash -c "find . -type f -exec chmod 644 {} \; && find . -type d -exec chmod 755 {} \;"'
  # Executable files.
  executables = %w(
    vendor/ext/imagesnap/imagesnap
    vendor/ext/videosnap/videosnap
    vendor/ext/CommandCam/CommandCam.exe
  )

  system "bash -c \"chmod +x ./bin/* #{executables.join(' ')}\""
end
Rake::Task[:build].prerequisites.unshift :ensure_executable_permissions

# rubocop
RuboCop::RakeTask.new

# tests
Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

# cucumber
ENV['CUCUMBER_PUBLISH_QUIET'] = 'true'
CLEAN.include("results.html")
Cucumber::Rake::Task.new(:features) do |t|
  opts = %w[ features --format html -o results.html --format progress -x ]
  opts << " --tags @#{ENV['tag']}" unless ENV['tag'].nil?
  t.cucumber_opts = opts
  t.fork = false
end

# default tasks
task default: %i[ rubocop test features ]
