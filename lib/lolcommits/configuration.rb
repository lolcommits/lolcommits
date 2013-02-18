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
      if is_fakecapture?
        'Fake'
      elsif is_mac?
        'Mac'
      elsif is_linux?
        'Linux'
      elsif is_windows?
        'Windows'
      else
        raise "Unknown / Unsupported Platform."
      end
    end

    def user_configuration
      if File.exists?(user_configuration_file)
        YAML.load(File.open(user_configuration_file))
      else
        nil
      end
    end

    def user_configuration_file
      "#{self.loldir}/config.yml"
    end

    def loldir
      return @loldir if @loldir

      basename ||= File.basename(Git.open('.').dir.to_s).sub(/^\./, 'dot')
      basename.sub!(/ /, '-')

      @loldir = Configuration.loldir_for(basename)
    end

    def self.loldir_for(basename)
      loldir = File.join(LOLBASEDIR, basename)

      if not File.directory? loldir
        FileUtils.mkdir_p loldir
      end
      loldir
    end

    def most_recent
      Dir.glob(File.join self.loldir, "*").max_by {|f| File.mtime(f)}
    end

    def raw_image
      File.join self.loldir, "tmp_snapshot.jpg"
    end

    def main_image(commit_sha)
      File.join self.loldir, "#{commit_sha}.jpg"
    end

    def puts_plugins
      names = Lolcommits::PLUGINS.collect {|p| p.new(nil).name }
      puts "Available plugins: #{names.join(', ')}"
    end

    def do_configure!(plugin, forced_options=nil)
      if plugin.nil? || plugin.strip == ''
        puts_plugins
        print "Name of plugin to configure: "
        plugin = STDIN.gets.strip
      end

      plugins = Lolcommits::PLUGINS.inject(Hash.new) do |acc, val|
        p = val.new(nil)
        acc.merge(p.name => p)
      end

      plugin_object = plugins[plugin]

      if plugin_object.nil?
        puts "Unable to find plugin: #{plugin}"
        return
      end

      if forced_options.nil?
        options = plugin_object.options.inject(Hash.new) do |acc, option|
          print "#{option}: "
          val = STDIN.gets.strip
          val = true  if val == 'true'
          val = false if val == 'false'

          acc.merge(option => val)
        end
      else
        options = forced_options
      end

      config = self.user_configuration || Hash.new
      config[plugin] = options
      File.open(self.user_configuration_file, 'w') do |f| 
        f.write(config.to_yaml)
      end 

      puts "#{config.to_yaml}\n"
      puts "Successfully Configured"
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

    def self.is_fakecapture?
      (ENV['LOLCOMMITS_FAKECAPTURE'] == '1' || false)
    end

    def self.valid_imagemagick_installed?
      return false unless self.command_which('identify')
      return false unless self.command_which('mogrify')
      # you'd expect the below to work on its own, but it only handles old versions
      # and will throw an exception if IM is not installed in PATH
      MiniMagick::valid_version_installed?
    end

    def self.git_config_color_always?
      `git config color.ui`.chomp =~ /always/
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
