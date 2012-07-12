require "lolcommits/image_processor"
require "fileutils"
require "open3"

module Lolcommits

  class LolImage
    attr_accessor :loldir, :captured_img, :processed_img, :captured_at, :processed_at

    def initialize( loldir )
      @loldir = loldir
    end

    def capture!(capture_delay=0, capture_device=nil, is_test=false)
      #
      # Create a directory to hold the lolimages
      #
      if not File.directory? @loldir
        FileUtils.mkdir_p @loldir
      end

      #
      # SMILE FOR THE CAMERA! 3...2...1...
      # We're just assuming the captured image is 640x480 for now, we may
      # need updates to the imagesnap program to manually set this (or resize)
      # if this changes on future mac isights.
      #
      puts "*** Preserving this moment in history."
      snapshot_loc = File.join @loldir, "tmp_snapshot.jpg"
      # if (ENV['LOLCOMMITS_FAKECAPTURE'] == '1' || false)
      if is_fakecapture?
        test_image = File.join LOLCOMMITS_ROOT, "test", "images", "test_image.jpg"
        FileUtils.cp test_image, snapshot_loc
      elsif is_mac?
        imagesnap_bin = File.join LOLCOMMITS_ROOT, "ext", "imagesnap", "imagesnap"
        capture_device = "-d '#{capture_device}'" if capture_device
        system("#{imagesnap_bin} -q #{snapshot_loc} -w #{capture_delay} #{capture_device}")
      elsif is_linux?
        tmpdir = File.expand_path "#{loldir}/tmpdir#{rand(1000)}/"
        FileUtils.mkdir_p( tmpdir )
        # There's no way to give a capture delay in mplayer, but a number of frame
        # I've found that 6 is a good value for me.
        frames = if capture_delay != 0 then capture_delay else 6 end

        # mplayer's output is ugly and useless, let's throw it away
        _, r, _ = Open3.popen3("mplayer -vo jpeg:outdir=#{tmpdir} -frames #{frames} tv://")
        # looks like we still need to read the output for something to happen
        r.read
        FileUtils.mv(tmpdir + "/%08d.jpg" % frames, snapshot_loc)
        FileUtils.rm_rf( tmpdir )
      elsif is_windows?
        commandcam_exe = File.join LOLCOMMITS_ROOT, "ext", "CommandCam", "CommandCam.exe"
        # DirectShow takes a while to show... at least for me anyway
        delaycmd = " /delay 3000"
        if capture_delay > 0
          # CommandCam delay is in milliseconds
          delaycmd = " /delay #{capture_delay * 1000}"
        end
        _, r, _ = Open3.popen3("#{commandcam_exe} /filename #{snapshot_loc}#{delaycmd}")
        # looks like we still need to read the output for something to happen
        r.read
      end
      @captured_at = Time.now
      @captured_img = snapshot_loc
    end

    def process!(commit_msg, commit_sha)
      ip = ImageProcessor.new( @captured_img, @loldir )
      @processed_img = ip.process!(commit_msg, commit_sha)

      #clean up the captured image
      FileUtils.rm(@captured_img)

      return @processed_img
    end

  end
end