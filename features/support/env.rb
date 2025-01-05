# frozen_string_literal: true

require 'aruba/cucumber'
require 'optparse_plus/cucumber'
require 'open3'
require 'ffaker'
require 'fileutils'

require File.join(__dir__, 'path_helpers')
include Lolcommits

World(PathHelpers)

Aruba.configure do |config|
  config.exit_timeout = 20
  # allow absolute paths for tests involving no repo
  config.allow_absolute_paths = true
end

Before do
  # prevent launchy from opening gifs in tests
  set_environment_variable 'LAUNCHY_DRY_RUN', 'true'
  set_environment_variable 'LOLCOMMITS_CAPTURER', 'Lolcommits::CaptureFake'

  author_name  = 'Testy McTesterson'
  author_email = 'testy@tester.com'

  set_environment_variable 'GIT_AUTHOR_NAME',     author_name
  set_environment_variable 'GIT_COMMITTER_NAME',  author_name
  set_environment_variable 'GIT_AUTHOR_EMAIL',    author_email
  set_environment_variable 'GIT_COMMITTER_EMAIL', author_email
end

# for tasks that may take an incredibly long time (e.g. network related)
# we should strive to not have any of these in our scenarios, naturally.
Before('@slow_process') do
  Aruba.configure do |config|
    config.exit_timeout = 60
  end
end

# in order to fake an interactive rebase, we replace the editor with a script
# to simply squash a few random commits. in this case, using lines 3-5.
Before('@fake-interactive-rebase') do
  set_environment_variable 'GIT_EDITOR', "sed -i -e '3,5 s/pick/squash/g'"
end

# adjust the path so tests dont see a global imagemagick install
Before('@fake-no-imagemagick') do
  reject_paths_with_cmd('magick')
end

# adjust the path so tests dont see a global ffmpeg install
Before('@fake-no-ffmpeg') do
  reject_paths_with_cmd('ffmpeg')
end
