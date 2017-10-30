module PopulateEnv
  module CLI
    class Runner
      attr_reader :argv, :output, :executable

      def initialize(argv: ARGV, output: $stdout, executable: File.basename($0))
        @argv, @output, @executable = Array(argv), output, executable
      end

      def run
        send(subcommand)
      end
      
      def help
        output.puts option_parser.to_s
      end
      
      def version
        output.puts "#{executable} version #{VERSION}"
      end
      
      def heroku
        options = CLI::HerokuOptions.parse(argv, command: "#{executable} heroku")
        PopulateEnv::Heroku.call(options)
      end
      
      private

      def option_parser
        @option_parser ||= OptionParser.new do |parser|
          parser.banner = <<-BANNER
Usage:
    #{executable} COMMAND [options]

Commands:
    heroku

Options:
          BANNER

          description = 'Show the help (combine with a command for full options)'
          parser.on('-h', '--help', description)

          description = "Show the current #{executable} version (#{VERSION})"
          parser.on('-v', '--version', description) { @subcommand = :version }
        end
      end

      def parse_options!
        option_parser.parse!(argv)
      rescue OptionParser::InvalidOption
      end

      def subcommand(fallback: :help)
        method_name = @subcommand || argv.shift || fallback
        respond_to?(method_name) ? method_name : fallback
      end
    end
  end
end
