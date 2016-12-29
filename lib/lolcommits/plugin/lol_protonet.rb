# -*- encoding : utf-8 -*-
require 'rest_client'

module Lolcommits
  module Plugin
    class LolProtonet < Base
      def initialize(runner)
        super
        options.concat(%w(api_token api_endpoint))
      end

      def run_postcapture
        return unless valid_configuration?

        debug "Posting capture to #{configuration['endpoint']}"
        RestClient.post(
          api_url,
          {
            files: [File.new(runner.main_image)],
            message: message
          },
          'X-Protonet-Token' => configuration['api_token']
        )
      end

      def api_url
        configuration['api_endpoint']
      end

      def message
        "commited some #{random_adjective} #{random_object} to #{runner.vcs_info.repo}@#{runner.sha} (#{runner.vcs_info.branch}) "
      end

      def random_object
        objects = %w(screws bolts exceptions errors cookies)

        objects.sample
      end

      def random_adjective
        adjectives = [
          'awesome', 'great', 'interesting', 'cool', 'EPIC', 'gut', 'good', 'pansy',
          'powerful', 'boring', 'quirky', 'untested', 'german', 'iranian', 'neutral', 'crazy', 'well tested',
          'jimmy style', 'nasty', 'bibliographical (we received complaints about the original wording)',
          'bombdiggidy', 'narly', 'spiffy', 'smashing', 'xing style',
          'leo apotheker style', 'black', 'white', 'yellow', 'shaggy', 'tasty', 'mind bending', 'JAY-Z',
          'Kanye (the best ever)', '* Toby Keith was here *', 'splendid', 'stupendulous',
          '(freedom fries!)', '[vote RON PAUL]', '- these are not my glasses -', 'typical pansy',
          '- ze goggles zey do nothing! -', 'almost working', 'legen- wait for it -', '-dairy!',
          ' - Tavonius would be proud of this - ', 'Meg FAILMAN!', '- very brofessional of you -',
          'heartbleeding', 'juciy', 'supercalifragilisticexpialidocious', 'failing', 'loving'
        ]
        adjectives.sample
      end

      def configured?
        !configuration['enabled'].nil? &&
          configuration['api_token'] &&
          configuration['api_endpoint']
      end

      def self.name
        'lolprotonet'
      end

      def self.runner_order
        :postcapture
      end
    end
  end
end
