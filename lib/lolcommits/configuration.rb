module Lolcommits
  class Configuration
    LOLCOMMITS_BASE = ENV["LOLCOMMITS_DIR"] || File.join(Dir.home, ".lolcommits")
    LOLCOMMITS_ROOT = File.join(File.dirname(__FILE__), "../..")

    attr_accessor :plugin_manager
    attr_writer :loldir

    def self.loldir_for(basename)
      loldir = File.join(LOLCOMMITS_BASE, basename)

      if File.directory? loldir
        begin
          # ensure 755 permissions for loldir
          File.chmod(0o755, loldir)
        rescue Errno::EPERM
          # abort if permissions cannot be met
          puts "FATAL: directory '#{loldir}' should be present and writeable by user '#{ENV.fetch('USER', nil)}'"
          puts "Try changing the directory permissions to 755"
          exit 1
        end
      else
        FileUtils.mkdir_p loldir
      end
      loldir
    end

    def initialize(plugin_manager, test_mode: false)
      @plugin_manager = plugin_manager
      @loldir         = Configuration.loldir_for("test") if test_mode
    end

    def yaml
      @yaml ||= if File.exist?(configuration_file)
                  YAML.safe_load(File.open(configuration_file), permitted_classes: [ Symbol ]) || Hash.new({})
      else
                  Hash.new({})
      end
    end

    def configuration_file
      "#{loldir}/config.yml"
    end

    def loldir
      return @loldir if @loldir

      basename ||= if VCSInfo.repo_root?
                     VCSInfo.local_name
      else
                     File.basename(Dir.getwd)
      end
      basename.sub!(/^\./, "dot")
      basename.sub!(/ /, "-")
      @loldir = Configuration.loldir_for(basename)
    end

    def sha_path(sha, ext)
      File.join loldir, "#{sha}.#{ext}"
    end

    def capture_path(ext = "jpg")
      File.join loldir, "raw_capture.#{ext}"
    end

    def list_plugins
      puts "Installed plugins: (* enabled)\n"

      plugin_manager.plugins.each do |gem_plugin|
        plugin = gem_plugin.plugin_klass.new(config: yaml[gem_plugin.name])
        puts " [#{plugin.enabled? ? '*' : '-'}] #{gem_plugin.name}"
      end
    end

    def find_plugin(name)
      plugin_name = name.empty? ? ask_for_plugin_name : name
      plugin = plugin_manager.find_by_name(plugin_name)

      return plugin if plugin

      puts "Unable to find plugin: '#{plugin_name}'"
      list_plugins unless name.empty?
      nil
    end

    def ask_for_plugin_name
      list_plugins
      print "Name of plugin to configure: "
      gets.strip
    end

    def do_configure!(plugin_name)
      $stdout.sync = true
      plugin = find_plugin(plugin_name.to_s.strip)
      return unless plugin

      puts "Configuring plugin: #{plugin.name}\n"
      plugin_config = plugin.plugin_klass.new(config: yaml[plugin_name]).configure_options! || {}

      unless plugin_config[:enabled]
        puts "Disabling plugin: #{plugin.name} - answer with 'true' to enable & configure"
      end
    rescue Interrupt
      # e.g. user Ctrl+c or aborted by plugin configure_options!
      puts "\n"
      if plugin
        puts "Configuration aborted: #{plugin.name} has been disabled"
        plugin_config ||= {}
        plugin_config[:enabled] = false
      end
    ensure
      if plugin
        # clean away legacy enabled key, later we can remove this
        plugin_config.delete("enabled")
        # save plugin config (if we have anything in the hash)
        save(plugin.name, plugin_config) unless plugin_config.empty?

        # print config if plugin was enabled
        if plugin_config[:enabled]
          puts "\nSuccessfully configured plugin: #{plugin.name} - at path '#{configuration_file}'"
          puts plugin_config.to_yaml
        end
      end
    end

    def save(plugin_name, plugin_config)
      config_file_contents = yaml.merge(plugin_name => plugin_config).to_yaml
      File.write(configuration_file, config_file_contents)
    end

    def to_s
      yaml.to_yaml.to_s
    end
  end
end
