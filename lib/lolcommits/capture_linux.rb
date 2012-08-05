module Lolcommits
  class CaptureLinux < Capturer
    def capture
      tmpdir = Dir.mktmpdir
      # There's no way to give a capture delay in mplayer, but a number of frame
      # I've found that 6 is a good value for me.
      frames = if capture_delay != 0 then capture_delay else 6 end

      # mplayer's output is ugly and useless, let's throw it away
      _, r, _ = Open3.popen3("mplayer -vo jpeg:outdir=#{tmpdir} -frames #{frames} tv://")
      # looks like we still need to read the output for something to happen
      r.read
      FileUtils.mv(tmpdir + "/%08d.jpg" % frames, snapshot_location)
      FileUtils.rm_rf( tmpdir )
    end

  end

end
