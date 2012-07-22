module Lolcommits
  class Capturer
    attr_accessor :capture_device, :capture_delay, :snapshot_location
    def initialize(attributes = Hash.new)
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end
    end
  end
end
