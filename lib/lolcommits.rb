$:.unshift File.expand_path('.')

require "lolcommits/version"
require "lolcommits/lolimage"
require "choice"
require "fileutils"
require "git"
require "launchy"
include Magick

module Lolcommits
  $home = ENV['HOME']
  LOLBASEDIR = ENV['LOLCOMMITS_DIR'] || (File.join $home, ".lolcommits")
  LOLCOMMITS_ROOT = File.join(File.dirname(__FILE__), '..')

  def most_recent(dir='.')
    loldir, commit_sha, commit_msg = parse_git
    Dir.glob(File.join loldir, "*").max_by {|f| File.mtime(f)}
  end

  def loldir(dir='.')
    loldir, commit_sha, commit_msg = parse_git
    return loldir
  end

  def parse_git(dir='.')
    g = Git.open(dir)
    commit = g.log.first
    commit_msg = commit.message.split("\n").first
    commit_sha = commit.sha[0..10]
    basename = File.basename(g.dir.to_s)
    basename.sub!(/^\./, 'dot') #no invisible directories in output, thanks!
    basename.sub!(/ /, '-') #no spaces plz
    loldir = File.join LOLBASEDIR, basename
    return loldir, commit_sha, commit_msg
  end

  def capture(capture_delay=0, capture_device=nil, is_test=false, test_msg=nil, test_sha=nil)
    #
    # Read the git repo information from the current working directory
    #
    if not is_test
      loldir, commit_sha, commit_msg = parse_git
    else
      commit_msg = test_msg
      commit_sha = test_sha
      loldir = File.join LOLBASEDIR, "test"
    end

    #
    # lolspeak translate the message
    #
    if (ENV['LOLCOMMITS_TRANZLATE'] == '1' || false)
        commit_msg = commit_msg.tranzlate
    end

    #capture and process image
    lolimg = LolImage.new(loldir)
    lolimg.capture!(capture_delay, capture_device, is_test)
    lolimg.process!(commit_msg, commit_sha)

    #if in test mode, open image for inspection
    if is_test
      Launchy.open( lolimg.processed_img )
    end
  end
  
  def is_mac?
    RUBY_PLATFORM.downcase.include?("darwin")
  end

  def is_linux?
    RUBY_PLATFORM.downcase.include?("linux")
  end

  def is_windows?
    if RUBY_PLATFORM =~ /(win|w)32$/
      true
    end
  end

  def is_fakecapture?
    (ENV['LOLCOMMITS_FAKECAPTURE'] == '1' || false)
  end
end
