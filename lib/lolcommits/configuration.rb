module Lolcommits
  class Configuration
    LOLBASEDIR = ENV['LOLCOMMITS_DIR'] || File.join(ENV['HOME'], '.lolcommits')
    LOLCOMMITS_ROOT = File.join(File.dirname(__FILE__), '../..')
    attr_writer :loldir

    def initialize(attributes={})
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end
    end

    def self.platform
      if is_fakeplatform?
        ENV['LOLCOMMITS_FAKEPLATFORM']
      elsif is_fakecapture?
        'Fake'
      elsif is_mac?
        'Mac'
      elsif is_linux?
        'Linux'
      elsif is_windows?
        'Windows'
      elsif is_cygwin?
        'Cygwin'
      else
        raise "Unknown / Unsupported Platform."
      end
    end

    def read_configuration
      if File.exists?(configuration_file)
        YAML.load(File.open(configuration_file))
      else
        nil
      end
    end

    def configuration_file
      "#{self.loldir}/config.yml"
    end

    def loldir
      return @loldir if @loldir

      basename ||= File.basename(Git.open('.').dir.to_s).sub(/^\./, 'dot')
      basename.sub!(/ /, '-')

      @loldir = Configuration.loldir_for(basename)
    end

    def archivedir
      dir = File.join(loldir, 'archive')
      if not File.directory? dir
        FileUtils.mkdir_p dir
      end
      dir
    end

    def self.loldir_for(basename)
      loldir = File.join(LOLBASEDIR, basename)

      if not File.directory? loldir
        FileUtils.mkdir_p loldir
      end
      loldir
    end

    def most_recent
      Dir.glob(File.join self.loldir, "*.jpg").max_by {|f| File.mtime(f)}
    end

    def images
      Dir.glob(File.join self.loldir, "*.jpg").sort_by {|f| File.mtime(f)}
    end

    def images_today
      images.select { |f| Date.parse(File.mtime(f).to_s) === Date.today }
    end

    def raw_image(image_file_type = 'jpg')
      File.join self.loldir, "tmp_snapshot.#{image_file_type}"
    end

    def main_image(commit_sha, image_file_type = 'jpg')
      File.join self.loldir, "#{commit_sha}.#{image_file_type}"
    end

    def video_loc
      File.join(self.loldir, 'tmp_video.mov')
    end

    def frames_loc
      File.join(self.loldir, 'tmp_frames')
    end

    def puts_plugins
      puts "Available plugins: #{Lolcommits::PLUGINS.map(&:name).join(', ')}"
    end

    def ask_for_plugin_name
      puts_plugins
      print "Name of plugin to configure: "
      STDIN.gets.strip
    end

    def find_plugin(plugin_name)
      Lolcommits::PLUGINS.each do |plugin|
        if plugin.name == plugin_name
          return plugin.new(nil)
        end
      end

      puts "Unable to find plugin: '#{plugin_name}'"
      puts_plugins
    end

    def do_configure!(plugin_name)
      if plugin_name.to_s.strip.empty?
        plugin_name = ask_for_plugin_name
      end

      if plugin = find_plugin(plugin_name)
        config = self.read_configuration || Hash.new
        plugin_config = plugin.configure_options!
        # having a plugin_config, means configuring went OK
        if plugin_config
          # save plugin and print config
          config[plugin_name] = plugin_config
          save(config)
          puts self
          puts "\nSuccessfully configured plugin: #{plugin_name}"
        else
          puts "\nAborted plugin configuration for: #{plugin_name}"
        end
      end
    end

    def save(config)
      config_file_contents = config.to_yaml
      File.open(self.configuration_file, 'w') do |f|
        f.write(config_file_contents)
      end
    end

    def to_s
      read_configuration.to_yaml.to_s
    end

    def self.is_mac?
      RUBY_PLATFORM.to_s.downcase.include?("darwin")
    end

    def self.is_linux?
      RUBY_PLATFORM.to_s.downcase.include?("linux")
    end

    def self.is_windows?
      !! RUBY_PLATFORM.match(/(win|w)32/)
    end

    def self.is_cygwin?
      RUBY_PLATFORM.to_s.downcase.include?("cygwin")
    end

    def self.is_fakecapture?
      (ENV['LOLCOMMITS_FAKECAPTURE'] == '1' || false)
    end

    def self.is_fakeplatform?
      ENV['LOLCOMMITS_FAKEPLATFORM']
    end

    def self.valid_imagemagick_installed?
      return false unless self.command_which('identify')
      return false unless self.command_which('mogrify')
      # you'd expect the below to work on its own, but it only handles old versions
      # and will throw an exception if IM is not installed in PATH
      MiniMagick::valid_version_installed?
    end

    def self.valid_ffmpeg_installed?
      self.command_which('ffmpeg')
    end

    def self.git_config_color_always?
      `git config color.ui`.chomp =~ /always/
    end

    def self.can_animate?
      platform == 'Mac'
    end

    # Cross-platform way of finding an executable in the $PATH.
    # idea taken from http://bit.ly/qDaTbY
    #
    #   which('ruby') #=> /usr/bin/ruby
    def self.command_which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = "#{path}/#{cmd}#{ext}"
          return exe if File.executable? exe
        }
      end
      return nil
    end

  end
end
