# -*- encoding : utf-8 -*-
require 'aruba/cucumber'
require 'methadone/cucumber'
require 'open3'
require 'ffaker'
require 'fileutils'

require File.join(File.expand_path(File.dirname(__FILE__)), 'path_helpers')
include Lolcommits

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

World(PathHelpers)

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @aruba_timeout_seconds = 20

  set_env 'LOLCOMMITS_FAKECAPTURE', '1'
  set_env 'LAUNCHY_DRY_RUN', 'true'
end

# in order to fake an interactive rebase, we replace the editor with a script
# to simply squash a few random commits. in this case, using lines 3-5.
Before('@fake-interactive-rebase') do
  set_env 'GIT_EDITOR', "sed -i -e '3,5 s/pick/squash/g'"
end

Before('@slow_process') do
  @aruba_io_wait_seconds = 5
  @aruba_timeout_seconds = 60
end

# adjust the path so tests dont see a global imagemagick install
Before('@fake-no-imagemagick') do
  reject_paths_with_cmd('mogrify')
end

After('@fake-no-imagemagick') do
  reset_path
end

# adjust the path so tests dont see a global ffmpeg install
Before('@fake-no-ffmpeg') do
  reject_paths_with_cmd('ffmpeg')
end

After('@fake-no-ffmpeg') do
  reset_path
end

# do test in temporary directory so our own git repo-ness doesn't affect it
Before('@in-tempdir') do
  @dirs = [Dir.mktmpdir]
end

After('@in-tempdir') do
  FileUtils.rm_rf(@dirs.first)
end
