module Lolcommits
  module CLI
    # Helper class for forking lolcommits process to the background (or not).
    class ProcessRunner
      # Initializes a new process runner.
      #
      # @param config [Lolcommits::Configuration]
      def initialize(config)
        @configuration = config
      end

      # Forks the lolcommits process if requested.
      #
      # Writes the PID of the lolcommits process to the filesystem when
      # backgrounded, for monitoring purposes.
      #
      # @param please [Boolean] whether or not to fork lolcommits process
      # @yield the main event loop for lolcommits
      def fork_me?(please, &block)
        if please
          $stdout.sync = true
          write_pid fork {
            yield block
            delete_pid
          }
        else
          yield block
        end
      end

      private

      def write_pid(pid)
        File.open(pid_file, 'w') { |f| f.write(pid) }
      end

      def delete_pid
        File.delete(pid_file) if File.exist?(pid_file)
      end

      def pid_file
        File.join(@configuration.loldir, 'lolcommits.pid')
      end
    end
  end
end
