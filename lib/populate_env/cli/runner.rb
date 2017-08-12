module PopulateEnv
  module CLI
    class Runner
      attr_reader :argv, :output, :executable

      def initialize(argv: ARGV, output: $stdout, executable: File.basename($0))
        @argv, @output, @executable = Array(argv), output, executable
      end

      def run
        option_parser.parse!(argv)
        send(@subcommand || argv.first || :help)
      end

      private

      def option_parser
        @option_parser ||= OptionParser.new do |opts|
          opts.banner = "Usage: #{executable} [options]"

          opts.on('-h', '--help', 'Show this help')

          description = "Show the current #{executable} version (#{VERSION})"
          opts.on('-v', '--version', description) { @subcommand = :version }
        end
      end

      def help
        output.puts option_parser.to_s
      end

      def version
        output.puts "#{executable} version #{VERSION}"
      end
    end
  end
end
