module PopulateEnv
  module Heroku
    class Compilation
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def manifest
        Manifest.new(options.manifest)
      end

      def attribute_definitions
        manifest.attribute_definitions_for(options.manifest_environment)
      end

      def remote_config
        @remote_config ||= RemoteConfig.new(options)
      end

      def sections
        attribute_definitions.map do |definition|
          attribute = AttributeCompilation.new(definition, options, remote_config).perform
          Formatters::EnvShellSection.new(attribute, export: options.export) if attribute
        end
      end

      def content
        sections.compact.join("\n")
      end
      
      def perform
        options.destination.write(content)
      end
    end
  end
end
