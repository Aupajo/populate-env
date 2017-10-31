require 'securerandom'

module PopulateEnv
  module Heroku
    class Options
      DEFAULTS = {
        manifest_environment: 'production',
        manifest: 'app.json',
        destination: '.env',
        generate_secrets: true,
        secret_generator: SecureRandom.method(:hex),
        use_heroku_config: true,
        heroku_app: nil,
        heroku_remote: nil,
        skip_local_env: false,
        prompt_missing: true,
        export: false,
        output: $stdout,
        input: $stdin,
        local_env: ENV
      }.freeze

      attr_accessor *DEFAULTS.keys

      def initialize(**attrs)
        attrs = DEFAULTS.merge(attrs)
        attrs.each { |attr, value| public_send("#{attr}=", value) }
      end

      def manifest=(value)
        @manifest = Pathname(value)
      end

      def destination=(value)
        @destination = Pathname(value)
      end

      def manifest_environment=(value)
        @manifest_environment = value.to_sym
      end
    end
  end
end
