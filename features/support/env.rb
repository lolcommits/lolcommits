require 'aruba/cucumber'
require 'methadone/cucumber'
require 'open3'
require 'test/unit/assertions'
include Test::Unit::Assertions
require 'faker'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @aruba_timeout_seconds = 20

  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s

  @original_fakecapture = ENV['LOLCOMMITS_FAKECAPTURE']
  ENV['LOLCOMMITS_FAKECAPTURE'] = "1"

  # @original_loldir = ENV['LOLCOMMITS_DIR']
  # ENV['LOLCOMMITS_DIR'] = File.expand_path( File.join(current_dir, ".lolcommits") )

  @original_home = ENV['HOME']
  ENV['HOME'] = File.expand_path( current_dir )

  ENV['LAUNCHY_DRY_RUN'] = 'true'
end

After do
  ENV['RUBYLIB'] = @original_rubylib
  ENV['LOLCOMMITS_FAKECAPTURE'] = @original_fakecapture
  # ENV['LOLCOMMITS_DIR'] = @original_loldir
  ENV['HOME'] = @original_home
  ENV['LAUNCHY_DRY_RUN'] = nil
end

Before('@fake-interactive-rebase') do
  # in order to fake an interactive rebase, 
  # we replace the editor with a script that simply squashes a few random commits
  @original_git_editor = ENV['GIT_EDITOR']
  # ENV['GIT_EDITOR'] = "sed -i -e 'n;s/pick/squash/g'" #every other commit
  ENV['GIT_EDITOR'] = "sed -i -e '3,5 s/pick/squash/g'" #lines 3-5
end

After('@fake-interactive-rebase') do
  ENV['GIT_EDITOR'] = @original_git_editor
end
