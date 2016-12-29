# -*- encoding : utf-8 -*-
require 'base64'

module Lolcommits
  module Plugin
    class TermOutput < Base
      def run_postcapture
        if terminal_supported?
          if !runner.vcs_info || runner.vcs_info.repo.empty?
            debug 'repo is empty, skipping term output'
          else
            base64 = Base64.encode64(open(runner.main_image, &:read))
            puts "#{begin_escape}1337;File=inline=1:#{base64};alt=#{runner.message};#{end_escape}\n"
          end
        else
          debug 'Disabled, your terminal is not supported (requires iTerm2)'
        end
      end

      def self.name
        'term_output'
      end

      def self.runner_order
        :postcapture
      end

      def configure_options!
        if terminal_supported?
          super
        else
          puts "Sorry, your terminal does not support the #{self.class.name} plugin (requires iTerm2)"
        end
      end

      private

      # escape sequences for tmux sessions differ
      def begin_escape
        tmux? ? "\033Ptmux;\033\033]" : "\033]"
      end

      def end_escape
        tmux? ? "\a\033\\" : "\a"
      end

      def tmux?
        !ENV['TMUX'].nil?
      end

      def terminal_supported?
        ENV['TERM_PROGRAM'] =~ /iTerm/
      end
    end
  end
end
