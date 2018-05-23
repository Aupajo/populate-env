require 'ostruct'

module PopulateEnv
  module CLI
    module HerokuOptions 
      module_function

      def parse(argv, command:, options: PopulateEnv::Heroku::Options.new)
        parser = OptionParser.new

        parser.accept(Pathname) { |path| Pathname(path) }

        parser.banner = "Usage: #{command} [options]"

        description = "Path to the app.json schema (defaults to #{options.manifest})"
        parser.on("--manifest FILE", Pathname, description) do |value|
          options.manifest = value
        end
        
        description = "File to write (defaults to #{options.destination})"
        parser.on("--destination FILE", Pathname, description) do |value|
          options.destination = value
        end

        description = "Environment to read from the app.json manifest (defaults to #{options.manifest_environment})"
        parser.on("-e", "--manifest-environment ENVIRONMENT", description) do |value|
          options.manifest_environment = value
        end

        description = "Skip environment variables currently set in your shell (defaults to #{options.skip_local_env})"
        parser.on("--[no-]skip-local-env", description) do |value|
          options.skip_local_env = value
        end
        
        description = "Populate missing environment variables from Heroku (defaults to #{options.use_heroku_config})"
        parser.on("--[no-]heroku-config", description) do |value|
          options.use_heroku_config = value
        end
        
        description = 'Heroku remote to use for reading config'
        parser.on("--heroku-remote GIT_REMOTE", description) do |value|
          options.heroku_remote = value
        end
        
        description = 'Heroku app to use for reading config'
        parser.on("--heroku-app APP_NAME", description) do |value|
          options.heroku_app = value
        end
        
        description = 'Whether to generate secrets'
        parser.on("--[no-]generate-secrets", description) do |value|
          options.generate_secrets = value
        end
        
        description = "Prompt the user for missing environment variables (defaults to #{options.prompt_missing})"
        parser.on("--[no-]prompt-missing", description) do |value|
          options.prompt_missing = value
        end

        description = "Prefix variable declarations in output with export (defaults to #{options.skip_local_env})"
        parser.on("--[no-]export", description) do |value|
          options.export = value
        end

        parser.parse!(argv)

        options
      end
    end
  end
end
