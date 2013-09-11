module Lolcommits
  class Capturer
    include Methadone::CLILogging
    attr_accessor :capture_device, :capture_delay, :snapshot_location, :font,
                  :video_location, :frames_location, :animated_duration

    def initialize(attributes = Hash.new)
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end
      debug "Capturer: initializing new instance " + self.to_s
    end
  end
end
