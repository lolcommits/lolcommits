require "lolcommits/version"
require "choice"
require "fileutils"
require "git"
require "RMagick"
include Magick

module Lolcommits
  # Your code goes here...
  $home = ENV['HOME']
  LOLBASEDIR = "#{$home}/.lolcommits"
  
  def capture(is_test=false, test_msg=nil, test_sha=nil)
    #
    # Read the git repo information from the current working directory
    #
    if not is_test
      g = Git.open('.')
      commit = g.log.first
      commit_msg = commit.message
      commit_sha = commit.sha[0..10]
      basename = File.basename(g.dir.to_s)
      basename.sub!(/^\./, 'dot') #no invisible directories in output, thanks!
      loldir = "#{LOLBASEDIR}/#{basename}"
    else
      commit_msg = test_msg #Choice.choices[:msg]
      commit_sha = test_sha #Choice.choices[:sha]
      loldir = "#{LOLBASEDIR}/test"
    end
    
    #puts "#{commit_sha}: #{commit_msg}"
    
    #
    # Create a directory to hold the lolimages
    #
    if not File.directory? loldir
      FileUtils.mkdir_p loldir
    end

    #
    # SMILE FOR THE CAMERA! 3...2...1...
    # We're just assuming the captured image is 640x480 for now, we may
    # need updates to the imagesnap program to manually set this (or resize)
    # if this changes on future mac isights.
    #
    puts "*** Preserving this moment in history."
    snapshot_loc = "#{loldir}/tmp_snapshot.jpg"
    system("imagesnap -q #{snapshot_loc} -w #{Choice.choices[:delay]}")
  
    
    #
    # Process the image with ImageMagick to add loltext
    #

    # read in the image, and resize it via the canvas
    canvas = ImageList.new("#{snapshot_loc}")
    if (canvas.columns > 640 || canvas.rows > 480)
      canvas.resize_to_fill!(640,480)
    end

    # create a draw object for annotation
    draw = Magick::Draw.new
    draw.font = "/Library/Fonts/Impact.ttf"
    draw.fill = 'white'
    draw.stroke = 'black'

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 28)
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
      self.interline_spacing = -(48 / 5)
      self.stroke_width = 2
    end

    #
    # Squash the images and write the files
    #
    #canvas.flatten_images.write("#{loldir}/#{commit_sha}.jpg")
    canvas.write("#{loldir}/#{commit_sha}.jpg")
    FileUtils.rm("#{snapshot_loc}")

    #if in test mode, open image for inspection
    if Choice.choices[:test]
      system("open #{loldir}/#{commit_sha}.jpg")
    end
    
    
  end
  
end
