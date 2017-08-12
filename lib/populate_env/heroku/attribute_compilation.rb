module PopulateEnv
  module Heroku
    class AttributeCompilation
      attr_reader :definition, :options, :remote_config

      def initialize(definition, options, remote_config)
        @definition, @options, @remote_config = definition, options, remote_config
      end

      def perform
        options.output.print "#{definition.name}:"
        
        attempt_to_populate_value

        unless @skip_log
          options.output.puts " #{@status_for_output || @value.inspect}"
          options.output.puts "  => #{@explanation}"
          options.output.puts
        end

        Attribute.new(definition, @value) unless @skip
      end

      private

      def attempt_to_populate_value
        if !options.skip_local_env && options.local_env[definition.name]
          skip_due_to_local_env_var
          return
        end
        
        if definition.default
          use_manifest_default
          return
        end
      
        if definition.generator == 'secret' && options.generate_secrets
          generate_secret
          return
        end

        if optional?
          skip_optional
          return
        end

        if options.use_heroku_config
          attempt_to_read_from_heroku_config
          return if @value
        end
      
        if options.prompt_missing
          prompt_user_for_missing_value
          return if @value
        end
      
        fail "Required environment variable #{definition.name} could not be populated!"
      end

      def required?
        definition.required?
      end

      def optional?
        definition.optional?
      end

      def generate_secret
        @value = options.secret_generator.call
        @explanation = "generated secret"
      end

      def skip_optional
        @status_for_output = "(skipped)"
        @explanation = "no value available"
      end

      def skip_due_to_local_env_var
        @status_for_output = "(skipped)"
        @explanation = "found in local ENV"
        @skip = true
      end

      def use_manifest_default
        @value = definition.default
        @explanation = "using default from #{options.manifest.basename}"
      end

      def attempt_to_read_from_heroku_config
        @value = remote_config[definition.name]
        
        if @value
          @explanation = "using value from Heroku (#{remote_config.heroku_app_flag.inspect})"
        end
      end

      def prompt_user_for_missing_value
        @value = MissingPrompt.call(definition, options)
        @skip_log = true
      end
    end
  end
end
