require 'aruba/cucumber'
require 'methadone/cucumber'
require 'open3'
require 'test/unit/assertions'
include Test::Unit::Assertions
require 'faker'
require 'lolcommits/configuration'
include Lolcommits

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

Before('@slow_process') do
  @aruba_io_wait_seconds = 5
  @aruba_timeout_seconds = 60
end

# adjust the path so tests dont see a global imagemagick install
Before('@fake-no-imagemagick') do

  # make a new subdir that still contains git and mplayer
  tmpbindir = File.expand_path(File.join @dirs, "bin")
  FileUtils.mkdir_p tmpbindir
  ["git","mplayer"].each do |cmd|
    whichcmd = Lolcommits::Configuration.command_which(cmd)
    unless whichcmd.nil?
      FileUtils.ln_s whichcmd, File.join(tmpbindir, File.basename(whichcmd))
    end
  end

  # use a modified version of Configuration::command_which to detect where IM is installed
  # and remove that from the path
  cmd = 'mogrify'
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  newpaths = ENV['PATH'].split(File::PATH_SEPARATOR).reject do |path|
    found_cmd = false
    exts.each { |ext|
      exe = "#{path}/#{cmd}#{ext}"
      found_cmd = true if File.executable? exe
    }
    found_cmd
  end

  # add the temporary directory with git in it back into the path
  newpaths << tmpbindir 

  @original_path = ENV['PATH']
  ENV['PATH'] = newpaths.join(File::PATH_SEPARATOR)
  puts ENV['PATH']
end

After('@fake-no-imagemagick') do
  ENV['PATH'] = @original_path
end