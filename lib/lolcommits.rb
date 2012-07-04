$:.unshift File.expand_path('.')

require "lolcommits/version"
require 'lolcommits/configuration'
require 'lolcommits/capture_mac'
require 'lolcommits/capture_linux'
require 'lolcommits/capture_windows'
require 'lolcommits/git_info'

require "tranzlate/lolspeak"
require "choice"
require "fileutils"
require "git"
require "RMagick"
require "open3"
require 'httmultiparty'
require 'active_support/inflector'

include Magick

module Lolcommits

  def capture(capture_delay=0, capture_device=nil, is_test=false, test_msg=nil, test_sha=nil)
    if not is_test
      git_info = GitInfo.new
      commit_sha, commit_msg = git_info.sha, git_info.message
    else
      commit_msg = test_msg
      commit_sha = test_sha
    end

    #
    # lolspeak translate the message
    #
    if (ENV['LOLCOMMITS_TRANZLATE'] == '1' || false)
        commit_msg = commit_msg.tranzlate
    end

    #
    # Create a directory to hold the lolimages
    #
    if not File.directory? Configuration.loldir
      FileUtils.mkdir_p Configuration.loldir
    end

    #
    # SMILE FOR THE CAMERA! 3...2...1...
    # We're just assuming the captured image is 640x480 for now, we may
    # need updates to the imagesnap program to manually set this (or resize)
    # if this changes on future mac isights.
    #
    puts "*** Preserving this moment in history."
    snapshot_loc = Configuration.raw_image(commit_sha) 

    capturer = "Lolcommits::Capture#{Configuration.platform}".constantize.new(
      :capture_device    => capture_device, 
      :capture_delay     => capture_delay, 
      :snapshot_location => snapshot_loc
    )
    capturer.capture


    #
    # Process the image with ImageMagick to add loltext
    #

    # read in the image, and resize it via the canvas
    canvas = ImageList.new("#{snapshot_loc}")
    if (canvas.columns > 640 || canvas.rows > 480)
      canvas.resize_to_fill!(640,480)
    end

    draw = Magick::Draw.new
    draw.font = File.join(Configuration::LOLCOMMITS_ROOT, "fonts", "Impact.ttf")

    draw.fill = 'white'
    draw.stroke = 'black'

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end

    draw.annotate(canvas, 0, 0, 0, 0, commit_sha) do
      self.gravity = NorthEastGravity
      self.pointsize = 32
      self.stroke_width = 2
    end

    draw.annotate(canvas, 0, 0, 0, 0, word_wrap(commit_msg)) do
      self.gravity = SouthWestGravity
      self.pointsize = 48
      self.interline_spacing = -(48 / 5) if self.respond_to?(:interline_spacing)
      self.stroke_width = 2
    end

    #
    # Squash the images and write the files
    #
    #canvas.flatten_images.write("#{Configuration.loldir}/#{commit_sha}.jpg")
    canvas.write(File.join Configuration.loldir, "#{commit_sha}.jpg")

    HTTMultiParty.post('http://freezing-day-1419.herokuapp.com/git_commits.json', 
      :body => {
        :git_commit => {
          :sha => commit_sha,
          :repo => 'omg', 
          :image => File.open(File.join(Configuration.loldir, "#{commit_sha}.jpg"))
      }
    })
    
    commit_sha
  end
end
