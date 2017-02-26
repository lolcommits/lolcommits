module Lolcommits
  module TestHelpers
    module FakeIO
      # stdout captured and returned
      # stdin mapped to inputs an IO stream seperated with enter key presses
      def fake_io_capture(inputs: [])
        input_stream = "#{inputs.join("\r\n")}\r\n"
        $stdin       = StringIO.new(input_stream)
        $stdout      = StringIO.new

        yield

        $stdout.string
      ensure
        $stdin = STDIN
        $stdout = STDOUT
      end
    end
  end
end
