# -*- encoding : utf-8 -*-
module Lolcommits
  class CaptureLinux < Capturer
    MPLAYER_FPS = 25

    def capture_device_string
      @capture_device.nil? ? nil : "-tv device=\"#{@capture_device}\""
    end

    def capture
      debug 'LinuxCapturer: making tmp directory'
      tmpdir = Dir.mktmpdir

      # Default delay is 1s
      delay = if capture_delay != 0 then capture_delay else 1 end

      # There's no way to give a capture delay in mplayer, but a number of frame
      # mplayer's "delay" is actually a number of frames at 25 fps
      # multiply the set value (in seconds) by 25
      frames = delay.to_i * MPLAYER_FPS

      debug 'LinuxCapturer: calling out to mplayer to capture image'
      # mplayer's output is ugly and useless, let's throw it away
      _, r, _ = Open3.popen3("#{executable_path} -vo jpeg:outdir=#{tmpdir} #{capture_device_string} -frames #{frames} -fps #{MPLAYER_FPS} tv://")
      # looks like we still need to read the output for something to happen
      r.read

      # the below SHOULD tell FileUtils actions to post their output if we are in debug mode
      include FileUtils::Verbose if logger.level == 0

      debug 'LinuxCapturer: calling out to mplayer to capture image'

      # get last frame from tmpdir (regardless of fps)
      all_frames = Dir.glob("#{tmpdir}/*.jpg").sort_by do |f|
        File.mtime(f)
      end

      FileUtils.mv(all_frames.last, snapshot_location)
      debug 'LinuxCapturer: cleaning up'
      FileUtils.rm_rf(tmpdir)
    end

    def executable_path
      'mplayer'
    end
  end
end
