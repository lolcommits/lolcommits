module Lolcommits
  PLUGINS = Lolcommits::Plugin.subclasses

  class Runner
    attr_accessor :capture_delay, :capture_device, :message, :sha,
      :snapshot_loc, :repo, :file

    include ActiveSupport::Callbacks
    define_callbacks :run
    set_callback :run, :before, :execute_lolcommits_tranzlate

    # Executed Last
    set_callback :run, :after,  :execute_lolcommits_dot_com
    set_callback :run, :after,  :execute_lolcommits_loltext
    # Executed First

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
      run_callbacks :run do
        puts "*** Preserving this moment in history."
        self.file = self.snapshot_loc = Configuration.raw_image(self.sha) 
        capturer = "Lolcommits::Capture#{Configuration.platform}".constantize.new(
          :capture_device    => self.capture_device, 
          :capture_delay     => self.capture_delay, 
          :snapshot_location => self.snapshot_loc
        )
        capturer.capture
      end
    end
  end

  protected
  # register a method called "execute_lolcommits_#{plugin_name}" 
  # for each subclass of plugin.  these methods should be used as
  # callbacks to the run method.
  Lolcommits::PLUGINS.each do |plugin|
    define_method "execute_#{plugin.to_s.underscore.gsub('/', '_')}" do
      plugin.new(self).execute
    end
  end
end
