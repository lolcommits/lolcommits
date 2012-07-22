module Lolcommits
  module Configuration
    LOLBASEDIR = ENV['LOLCOMMITS_DIR'] || File.join(ENV['HOME'], '.lolcommits')
    LOLCOMMITS_ROOT = File.join(File.dirname(__FILE__), '../..')

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

    def self.user_configuration
      if File.exists?(user_configuration_file)
        YAML.load(File.open(user_configuration_file))
      else
        nil
      end
    end

    def self.user_configuration_file
      "#{loldir}/config.yml"
    end

    def self.loldir
      return @loldir if @loldir

      basename ||= File.basename(Git.open('.').dir.to_s).sub(/^\./, 'dot')
      basename.sub!(/ /, '-')
      @loldir = File.join(LOLBASEDIR, basename)

      if not File.directory? @loldir
        FileUtils.mkdir_p @loldir
      end
      @loldir
    end

    def self.most_recent
      Dir.glob(File.join self.loldir, "*").max_by {|f| File.mtime(f)}
    end

    def self.raw_image(commit_sha)
      File.join Configuration.loldir, "raw.#{commit_sha}.jpg"
    end

    def self.do_configure!(plugin)
      if plugin.nil? || plugin.strip == ''
        print "Plugin Name: "
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

      options = plugin_object.options.inject(Hash.new) do |acc, option|
        print "#{option}: "
        val = STDIN.gets.strip
        val = true  if val == 'true'
        val = false if val == 'false'

        acc.merge(option => val)
      end
      config = Lolcommits::Configuration.user_configuration || Hash.new
      config[plugin] = options
      File.open(Lolcommits::Configuration.user_configuration_file, 'w') do |f| 
        f.write(config.to_yaml)
      end 

      puts "#{config.to_yaml}\n"
      puts "Successfully Configured"
    end

    def self.is_mac?
      RUBY_PLATFORM.downcase.include?("darwin")
    end

    def self.is_linux?
      RUBY_PLATFORM.downcase.include?("linux")
    end

    def self.is_windows?
      !! RUBY_PLATFORM.match(/(win|w)32/)
    end

    def self.is_fakecapture?
      (ENV['LOLCOMMITS_FAKECAPTURE'] == '1' || false)
    end

  end
end
