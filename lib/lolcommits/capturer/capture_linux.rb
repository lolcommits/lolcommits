# -*- encoding : utf-8 -*-
module Lolcommits
  class CaptureLinux < Capturer
    def capture_device_string
      @capture_device.nil? ? nil : "-tv device=\"#{@capture_device}\""
    end

    def capture
      debug 'LinuxCapturer: making tmp directory'
      tmpdir = Dir.mktmpdir

      # Default delay is 1s
      delay = if capture_delay != 0 then capture_delay else 1 end

      # There's no way to give a capture delay in mplayer, but a number of frame
      # mplayer's "delay" is actually a number of frames at 25fps
      # multiply the set value (in seconds) by 25
      frames = delay.to_i * 25

      debug 'LinuxCapturer: calling out to mplayer to capture image'
      # mplayer's output is ugly and useless, let's throw it away
      _, r, _ = Open3.popen3("#{executable_path} -vo png:outdir=#{tmpdir} #{capture_device_string} -frames #{frames} tv://")
      # looks like we still need to read the output for something to happen
      r.read

      # the below SHOULD tell FileUtils actions to post their output if we are in debug mode
      include FileUtils::Verbose if logger.level == 0

      debug 'LinuxCapturer: calling out to mplayer to capture image'
      FileUtils.mv(tmpdir + '/%08d.png' % frames, snapshot_location)
      debug 'LinuxCapturer: cleaning up'
      FileUtils.rm_rf(tmpdir)
    end

    def executable_path
      'mplayer'
    end
  end
end
