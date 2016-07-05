# need to use popen3 on windows - popen4 always eventually calls fork
if Lolcommits::Platform.platform_windows?

  module Mercurial
    class Command
      private

      def execution_proc
        proc do
          debug(command)
          result = ''
          error = ''
          status = nil
          Open3.popen3(command) do |_stdin, stdout, stderr, wait_thread|
            Timeout.timeout(timeout) do
              while (tmp = stdout.read(102_400))
                result += tmp
              end
            end

            while (tmp = stderr.read(1024))
              error += tmp
            end
            status = wait_thread.value
          end
          raise_error_if_needed(status, error)
          result
        end
      end
    end
  end
end
