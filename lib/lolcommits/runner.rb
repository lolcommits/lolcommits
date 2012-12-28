module Lolcommits
  PLUGINS = Lolcommits::Plugin.subclasses
  include Magick

  class Runner
    attr_accessor :capture_delay, :capture_device, :message, :sha,
      :snapshot_loc, :main_image, :repo, :config, :repo_internal_path

    include ActiveSupport::Callbacks
    define_callbacks :run
    set_callback :run, :before, :execute_lolcommits_tranzlate

    # Executed Last
    set_callback :run, :after,  :cleanup!
    set_callback :run, :after,  :execute_lolcommits_uploldz
    set_callback :run, :after,  :execute_lolcommits_lol_twitter
    set_callback :run, :after,  :execute_lolcommits_stats_d
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
        self.repo_internal_path = git_info.repo_internal_path
      end
    end

    def run
      die_if_rebasing!

      run_callbacks :run do
        puts "*** Preserving this moment in history."
        self.snapshot_loc = self.config.raw_image
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
  def die_if_rebasing!
    if not self.repo_internal_path.nil?
      mergeclue = File.join self.repo_internal_path, "rebase-merge"
      if File.directory? mergeclue
        exit 0
      end
    end
  end

  def resize_snapshot!
    image = Sorcery.new(self.snapshot_loc)
    if (image.dimensions[:x].to_i > 640 || image.dimensions[:y].to_i > 480)
      # canvas.resize_to_fill!(640,480)
      # Remember this requires IM v6.3.8-3 or greater to make use of it. Otherwise use the older Resizing to Fill a Given Space technique below.
      image.convert(self.snapshot_loc, { :resize => '640x480^', :gravity => 'center', :extent => '640x480'})
    end
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
