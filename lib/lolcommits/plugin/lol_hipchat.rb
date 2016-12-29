# -*- encoding : utf-8 -*-
module Lolcommits
  module Plugin
    class LolHipchat < Base
      def configure_options!
        options = super
        options.merge! configure_auth_options if options['enabled']
        options
      end

      def configure_auth_options
        puts '-' * 50
        puts ' Lolcommits HipChat Plugin Configuration'
        puts '-' * 50

        puts '1.) I need your Team Name '
        puts 'teamname as in teamname.hipchat.com, without .hipchat.com'
        print 'Your Teamname: '
        teamname = STDIN.gets.to_s.strip
        puts "2.) We need a Authentication Token, get yours at https://#{teamname}.hipchat.com/account/api"
        puts 'make sure to select scope "Send Message"'
        print 'Your auth_token: '
        token = STDIN.gets.to_s.strip
        puts '3.) Which Room should be we post to?'
        puts 'can be a id or name'
        print 'Your Room: '
        room = STDIN.gets.to_s.strip

        {
          'api_token' => token,
          'api_team' => teamname,
          'api_room' => room
        }
      end

      def run_postcapture
        return unless valid_configuration?

        http = Net::HTTP.new(api_url.host, api_url.port)
        # http.set_debug_output $stderr # nice for debugging, never ever release with it
        http.start do |connection|
          header = { 'Content-Type' => 'multipart/related; boundary=0123456789ABLEWASIEREISAWELBA9876543210' }
          data = [message_part, picture_part].map do |part|
            "--0123456789ABLEWASIEREISAWELBA9876543210\r\n#{part}"
          end.join('') << '--0123456789ABLEWASIEREISAWELBA9876543210--'
          connection.post("#{api_url.path}?#{api_url.query}", data, header)
        end
      end

      def message_part
        [
          'Content-Type: application/json; charset=UTF-8',
          'Content-Disposition: attachment; name="metadata"',
          '',
          message_json,
          ''
        ].join "\r\n"
      end

      def message_json
        { message: message }.to_json.force_encoding('utf-8')
      end

      def picture_part
        mime_type = MIME::Types.type_for(picture.path)[0] || MIME::Types['application/octet-stream'][0]
        [
          format('Content-Type: %s', mime_type.simplified),
          format('Content-Disposition: attachment; name="file"; filename="%s"', picture.path),
          '',
          "#{picture.read} ",
          ''
        ].join "\r\n"
      end

      def picture
        @picture ||= File.new(runner.main_image)
      end

      def api_url
        URI(format('http://%{api_team}.hipchat.com/v2/room/%{api_room}/share/file?auth_token=%{api_token}', symbolized_configuration))
      end

      def symbolized_configuration
        @symbolized_configuration ||= configuration.each_with_object({}) { |(k, v), obj| obj[k.to_sym] = v }
      end

      def message
        "commited some #{random_adjective} #{random_object} to #{runner.vcs_info.repo}@#{runner.sha} (#{runner.vcs_info.branch}) "
      end

      def random_object
        objects = %w(screws bolts exceptions errors cookies)

        objects.sample
      end

      def random_adjective
        adjectives = %w(adaptable adventurous affable affectionate agreeable ambitious amiable amicable amusing brave \
                        bright broad-minded calm careful charming communicative compassionate conscientious considerate \
                        convivial courageous courteous creative decisive determined diligent diplomatic discreet dynamic \
                        easygoing emotional energetic enthusiastic exuberant fair-minded faithful fearless forceful \
                        frank friendly funny generous gentle good gregarious hard-working helpful honest humorous \
                        imaginative impartial independent intellectual intelligent intuitive inventive kind loving loyal \
                        modest neat nice optimistic passionate patient persistent pioneering philosophical placid plucky \
                        polite powerful practical pro-active quick-witted quiet rational reliable reserved resourceful \
                        romantic self-confident self-disciplined sensible sensitive shy sincere sociable straightforward \
                        sympathetic thoughtful tidy tough unassuming understanding versatile warmhearted willing witty)
        adjectives.sample
      end

      def configured?
        super &&
          configuration['api_token'] &&
          configuration['api_team'] &&
          configuration['api_room']
      end

      def self.name
        'hipchat'
      end

      def self.runner_order
        :postcapture
      end
    end
  end
end
