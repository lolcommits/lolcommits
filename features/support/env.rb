require 'aruba/cucumber'
require 'methadone/cucumber'
require 'open3'
require 'test/unit/assertions'
include Test::Unit::Assertions

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
