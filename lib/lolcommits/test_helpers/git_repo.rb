module Lolcommits
  module TestHelpers
    module GitRepo
      def repo
        @repo ||= Git.open(repo_path)
      end

      def repo_path
        '~/.lolcommits/plugin-test-repo'
      end

      def repo_exists?
        File.directory?(File.expand_path(repo_path, '.git'))
      end

      def last_commit
        repo.log.first
      end

      def setup_repo
        return if repo_exists?
        `git init --quiet #{repo_path}`
      end

      def commit_repo_with_message(message = 'test message', file_name: 'test.txt', file_content: 'testing')
        setup_repo unless repo_exists?
        `echo '#{file_content}' >> #{repo_path}/#{file_name}`
        `cd #{repo_path} && git add #{file_name}`
        `cd #{repo_path} && git commit -m "#{message}"`
      end

      def in_repo
        return unless repo_exists?
        Dir.chdir(File.expand_path(repo_path)) do
          yield
        end
      end

      def teardown_repo
        `rm -rf #{repo_path}`
      end
    end
  end
end
