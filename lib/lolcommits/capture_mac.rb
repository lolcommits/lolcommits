module Lolcommits
  class CaptureMac
    attr_accessor :capture_device, :capture_delay, :snapshot_location
    def initialize(attributes = Hash.new)
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end
    end

    def capture_device_string
      @capture_device.nil? ? nil : "-d #{@capture_device}"
    end

    def capture
      system("#{imagesnap_bin} -q #{snapshot_location} -w #{capture_delay} #{capture_device_string}")
    end

  end

  private

  def imagesnap_bin
      File.join(Configuration::LOLCOMMITS_ROOT, "ext", "imagesnap", "imagesnap")
  end
end
