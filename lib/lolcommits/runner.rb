module Lolcommits
  PLUGINS = Lolcommits::Plugin.subclasses
  include Magick

  class Runner
    attr_accessor :capture_delay, :capture_device, :message, :sha,
      :snapshot_loc, :main_image, :repo, :config

    include ActiveSupport::Callbacks
    define_callbacks :run
    set_callback :run, :before, :execute_lolcommits_tranzlate

    # Executed Last
    set_callback :run, :after,  :cleanup!
    set_callback :run, :after,  :execute_lolcommits_dot_com
    set_callback :run, :after,  :execute_lolcommits_loltext
    # Executed First

    def initialize(attributes={})
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end
      
      if self.sha.nil? || self.message.nil?
        git_info = GitInfo.new
        self.sha = git_info.sha if self.sha.nil?
        self.message = git_info.message if self.message.nil?
      end
    end

    def run
      run_callbacks :run do
        puts "*** Preserving this moment in history."
        self.snapshot_loc = self.config.raw_image(self.sha) 
        self.main_image   = self.config.main_image(self.sha)
        capturer = "Lolcommits::Capture#{Configuration.platform}".constantize.new(
          :capture_device    => self.capture_device, 
          :capture_delay     => self.capture_delay, 
          :snapshot_location => self.snapshot_loc
        )
        capturer.capture
        resize_snapshot!
      end
    end
  end

  protected

  def resize_snapshot!
    canvas = ImageList.new(self.snapshot_loc)
    if (canvas.columns > 640 || canvas.rows > 480)
      canvas.resize_to_fill!(640,480)
    end
    canvas.write(self.snapshot_loc)
    FileUtils.cp(self.snapshot_loc, self.main_image)
  end

  def cleanup!
    #clean up the captured image
    FileUtils.rm(self.snapshot_loc)
  end

  # register a method called "execute_lolcommits_#{plugin_name}" 
  # for each subclass of plugin.  these methods should be used as
  # callbacks to the run method.
  Lolcommits::PLUGINS.each do |plugin|
    define_method "execute_#{plugin.to_s.underscore.gsub('/', '_')}" do
      plugin.new(self).execute
    end
  end
end
