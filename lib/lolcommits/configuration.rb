module Lolcommits
  class Configuration
    LOLCOMMITS_BASE = ENV['LOLCOMMITS_DIR'] || File.join(ENV['HOME'], '.lolcommits')
    LOLCOMMITS_ROOT = File.join(File.dirname(__FILE__), '../..')

    attr_accessor :plugin_manager
    attr_writer :loldir

    def initialize(plugin_manager, test_mode: false)
      @plugin_manager = plugin_manager
      @loldir         = Configuration.loldir_for('test') if test_mode
    end

    def read_configuration
      return {} unless File.exist?(configuration_file)
      # TODO: change to safe_load when Ruby 2.0.0 support drops
      # YAML.safe_load(File.open(configuration_file), [Symbol])
      YAML.load(File.open(configuration_file)) || Hash.new({})
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
      basename.sub!(/^\./, 'dot')
      basename.sub!(/ /, '-')
      @loldir = Configuration.loldir_for(basename)
    end

    def archivedir
      dir = File.join(loldir, 'archive')
      FileUtils.mkdir_p dir unless File.directory? dir
      dir
    end

    def jpg_images
      Dir.glob(File.join(loldir, '*.jpg')).sort_by { |f| File.mtime(f) }
    end

    def jpg_images_today
      jpg_images.select { |f| Date.parse(File.mtime(f).to_s) == Date.today }
    end

    def raw_image(image_file_type = 'jpg')
      File.join loldir, "tmp_snapshot.#{image_file_type}"
    end

    def main_image(commit_sha, image_file_type = 'jpg')
      File.join loldir, "#{commit_sha}.#{image_file_type}"
    end

    def video_loc
      File.join(loldir, 'tmp_video.mov')
    end

    def frames_loc
      File.join(loldir, 'tmp_frames')
    end

    def list_plugins
      config = read_configuration
      puts "Installed plugins: (+ enabled)\n"

      plugin_manager.plugin_names.each do |name|
        puts " [#{config[name] && config[name]['enabled'] ? '+' : '-'}] #{name}"
      end
    end

    def find_plugin(plugin_name_option)
      plugin_name = plugin_name_option.empty? ? ask_for_plugin_name : plugin_name_option
      return if plugin_name.empty?

      plugin_klass = plugin_manager.find_by_name(plugin_name)
      return plugin_klass.new(config: self) if plugin_klass

      puts "Unable to find plugin: '#{plugin_name}'"
      return if plugin_name_option.empty?
      list_plugins
    end

    def ask_for_plugin_name
      list_plugins
      print 'Name of plugin to configure: '
      gets.strip
    end

    def do_configure!(plugin_name)
      $stdout.sync = true
      plugin = find_plugin(plugin_name.to_s.strip)
      return unless plugin

      config        = read_configuration
      plugin_name   = plugin.class.name
      plugin_config = plugin.configure_options!
    rescue Interrupt
      # e.g. user Ctrl+c or aborted by plugin configure_options!
      if plugin
        puts "\nConfiguration aborted: #{plugin_name} has been disabled"
        plugin_config ||= {}
        plugin_config['enabled'] = false
      else
        puts "\n"
      end
    ensure
      if plugin
        # set and save plugin config
        config[plugin_name] = plugin_config
        save(config)

        # print config if plugin was enabled
        if plugin_config && plugin_config['enabled']
          puts "\nSuccessfully configured plugin: #{plugin_name} - at path '#{configuration_file}'"
          puts read_configuration[plugin_name].to_yaml.to_s
        end
      end
    end

    def save(config)
      config_file_contents = config.to_yaml
      File.open(configuration_file, 'w') do |f|
        f.write(config_file_contents)
      end
    end

    def to_s
      read_configuration.to_yaml.to_s
    end

    # class methods

    def self.loldir_for(basename)
      loldir = File.join(LOLCOMMITS_BASE, basename)

      if File.directory? loldir
        begin
          # ensure 755 permissions for loldir
          File.chmod(0o755, loldir)
        rescue Errno::EPERM
          # abort if permissions cannot be met
          puts "FATAL: directory '#{loldir}' should be present and writeable by user '#{ENV['USER']}'"
          puts 'Try changing the directory permissions to 755'
          exit 1
        end
      else
        FileUtils.mkdir_p loldir
      end
      loldir
    end
  end
end
