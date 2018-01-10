module Lolcommits
  module Plugin
    module ConfigurationHelper
      # handle for bools, strings, ints and blanks from user input
      def parse_user_input(str)
        if 'true'.casecmp(str).zero?
          true
        elsif 'false'.casecmp(str).zero?
          false
        elsif str =~ /^[0-9]+$/
          str.to_i
        elsif str.strip.empty?
          nil
        else
          str
        end
      end

      # user input with autocomplete (via tab) through array of named values
      #
      # e.g.
      # prompt_autocomplete_hash("Organization: ", orgs)
      #
      # where orgs are an array of hashes like so (with string keys):
      # [
      #   { 'name' => 'some human readable name', 'value' => 1234 },
      # ]
      # User will be asked for Organization, can tab to autocomplete, and chosen
      # value is returned.
      def prompt_autocomplete_hash(prompt, items, name: 'name', value: 'value', suggest_words: 5)
        words = items.map { |item| item[name] }.sort
        puts "e.g. #{words.take(suggest_words).join(', ')}" if suggest_words > 0
        completed_input = gets_autocomplete(prompt, words)
        items.find { |item| item[name] == completed_input }[value]
      end

      private

      def gets_autocomplete(prompt, words)
        completion_handler = proc { |s| words.grep(/^#{Regexp.escape(s)}/) }
        Readline.completion_append_character = ''
        Readline.completion_proc = completion_handler

        while (line = Readline.readline(prompt, true).strip)
          return line if words.include?(line)
          puts "'#{line}' not found"
        end
      end
    end
  end
end
