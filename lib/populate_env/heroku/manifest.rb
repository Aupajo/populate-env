require 'json'

module PopulateEnv
  module Heroku
    class Manifest
      def initialize(path)
        @path = path
      end

      def attribute_definitions_for(environment)
        begin
          data = JSON.parse(@path.read, symbolize_names: true)
          env_vars = data.fetch(:env, {})
          env_vars.merge!(data.dig(:environments, environment.to_sym, :env) || {})

          env_vars.map do |key, value|
            if value.is_a?(Hash)
              default = value.delete(:value)
              value.merge!(name: key, default: default)
              AttributeDefinition.new(value)
            else
              AttributeDefinition.new(name: key, default: value)
            end
          end
        rescue Errno::ENOENT
          fail "Manifest file #{@path.to_s.inspect} not found"
        rescue JSON::ParserError
          fail "Could not parse JSON in #{@path.to_s.inspect}"
        end
      end
    end
  end
end
