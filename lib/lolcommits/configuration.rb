module Lolcommits
  module Configuration
    LOLBASEDIR = File.join(ENV['HOME'], '.lolcommits')
    LOLCOMMITS_ROOT = File.join(File.dirname(__FILE__), '../..')

    def self.platform
      if is_mac?
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
      conf_file = "#{loldir}/config.yml"
      YAML.load(File.open(conf_file))
    end

    def self.loldir
      return @loldir if @loldir

      @basename ||= File.basename(Git.open('.').dir.to_s).sub(/^\./, 'dot')
      @loldir = File.join(LOLBASEDIR, @basename)

      if not File.directory? @loldir
        FileUtils.mkdir_p @loldir
      end
      @loldir
    end

    def self.most_recent
      loldir, commit_sha, commit_msg = parse_git
      Dir.glob(File.join loldir, "*").max_by {|f| File.mtime(f)}
    end

    def self.raw_image(commit_sha)
      File.join Configuration.loldir, "raw.#{commit_sha}.jpg"
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
  end
end
