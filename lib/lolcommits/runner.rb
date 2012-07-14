module Lolcommits
  class Runner
    attr_accessor :capture_delay, :capture_device, :message, :sha,
      :snapshot_loc, :repo

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
      tranzlate!

      puts "*** Preserving this moment in history."
      self.snapshot_loc = Configuration.raw_image(self.sha) 
      capturer = "Lolcommits::Capture#{Configuration.platform}".constantize.new(
        :capture_device    => self.capture_device, 
        :capture_delay     => self.capture_delay, 
        :snapshot_location => self.snapshot_loc
      )
      capturer.capture

      write_loltext!
      post_to_heroku!
    end


    def tranzlate!
      if (ENV['LOLCOMMITS_TRANZLATE'] == '1' || false)
        self.message = message.tranzlate
      end
    end

    def post_to_heroku!
      configuration = Configuration.user_configuration['dot_com']

      t = Time.now.to_i.to_s
      resp = HTTMultiParty.post('http://www.lolcommits.com/git_commits.json', 
        :body => {
          :git_commit => {
            :sha   => self.sha,
            :repo  => self.repo, 
            :image => File.open(File.join(Configuration.loldir, "#{self.sha}.jpg"))
          },

          :key   => configuration['api_key'],
          :t     => t,
          :token =>  Digest::SHA1.hexdigest(configuration['api_secret'] + t)
        }
      )

    end

    def write_loltext!
      canvas = ImageList.new(self.snapshot_loc)
      if (canvas.columns > 640 || canvas.rows > 480)
        canvas.resize_to_fill!(640,480)
      end

      draw = Magick::Draw.new
      draw.font = File.join(Configuration::LOLCOMMITS_ROOT, "fonts", "Impact.ttf")

      draw.fill   = 'white'
      draw.stroke = 'black'

      draw.annotate(canvas, 0, 0, 0, 0, self.sha) do
        self.gravity = NorthEastGravity
        self.pointsize = 32
        self.stroke_width = 2
      end

      draw.annotate(canvas, 0, 0, 0, 0, word_wrap(self.message)) do
        self.gravity = SouthWestGravity
        self.pointsize = 48
        self.interline_spacing = -(48 / 5) if self.respond_to?(:interline_spacing)
        self.stroke_width = 2
      end

      canvas.write(File.join Configuration.loldir, "#{self.sha}.jpg")
    end


    private

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end
  end
end
