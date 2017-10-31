require 'set'

module PopulateEnv
  module Heroku
    class RemoteConfig
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def [](name)
        data[name]
      end

      def heroku_app_flag
        @heroku_app_flag ||= determine_heroku_app_flag!
      end

      private

      def data
        @data ||= fetch_data!
      end

      def fetch_data!
        if heroku_app_flag
          command_output = ShellCommand.run("heroku config --json #{heroku_app_flag}")

          begin
            JSON.parse(command_output)
          rescue JSON::ParserError
            fail "Could not parse JSON in `#{command}`:\n#{command_output}"
          end
        else
          {}
        end
      end

      def determine_heroku_app_flag!
        if options.heroku_app
          heroku_app_flag = "--app #{options.heroku_app}"
        elsif options.heroku_remote
          heroku_app_flag = "--remote #{options.heroku_remote}"
        else
          fail 'More than one Heroku remote' if git_remotes.length > 1

          if git_remotes.length == 1
            heroku_app_flag = "--remote #{git_remotes.first}"
          end
        end
      end

      def git_remotes
        @git_remotes ||= begin
          raw_remotes = ShellCommand.run('git remote --verbose').split("\n")

          raw_remotes.each_with_object(Set.new) do |line, remotes|
            remote, url, _ = line.split
            remotes << remote if url.include?('heroku.com')
          end
        end
      end
    end
  end
end
