module Lolcommits
  class CaptureLinux < Capturer
    def capture
      debug "LinuxCapturer: making tmp directory"
      tmpdir = Dir.mktmpdir

      # There's no way to give a capture delay in mplayer, but a number of frame
      # I've found that 6 is a good value for me.
      frames = if capture_delay != 0 then capture_delay else 6 end

      debug "LinuxCapturer: calling out to mplayer to capture image"
      # mplayer's output is ugly and useless, let's throw it away
      _, r, _ = Open3.popen3("mplayer -vo jpeg:outdir=#{tmpdir} -frames #{frames} tv://")
      # looks like we still need to read the output for something to happen
      r.read

      # the below SHOULD tell FileUtils actions to post their output if we are in debug mode
      include FileUtils::Verbose if logger.level == 0

      debug "LinuxCapturer: calling out to mplayer to capture image"
      FileUtils.mv(tmpdir + "/%08d.jpg" % frames, snapshot_location)
      debug "LinuxCapturer: cleaning up"
      FileUtils.rm_rf( tmpdir )
    end

  end

end
