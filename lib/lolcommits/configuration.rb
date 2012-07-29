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

    def do_configure!(plugin)
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

      options = plugin_object.options.inject(Hash.new) do |acc, option|
        print "#{option}: "
        val = STDIN.gets.strip
        val = true  if val == 'true'
        val = false if val == 'false'

        acc.merge(option => val)
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
