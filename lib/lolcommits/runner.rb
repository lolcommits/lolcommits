module Lolcommits
  class Runner
    attr_accessor :capture_delay, :capture_device, :message, :sha,
      :snapshot_loc, :repo, :file

    def initialize(attributes={})
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end
      
      git_info = GitInfo.new
      self.sha = git_info.sha if self.sha.nil?
      self.message = git_info.message if self.message.nil?
      self.repo = git_info.repo
    end

    def run
      tranzlate!

      puts "*** Preserving this moment in history."
      self.file = self.snapshot_loc = Configuration.raw_image(self.sha) 
      capturer = "Lolcommits::Capture#{Configuration.platform}".constantize.new(
        :capture_device    => self.capture_device, 
        :capture_delay     => self.capture_delay, 
        :snapshot_location => self.snapshot_loc
      )
      capturer.capture

      Lolcommits::Loltext.new(self).execute
      Lolcommits::DotCom.new(self).execute
    end


    def tranzlate!
      if (ENV['LOLCOMMITS_TRANZLATE'] == '1' || false)
        self.message = message.tranzlate
      end
    end

  end
end
