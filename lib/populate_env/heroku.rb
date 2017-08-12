require 'ostruct'

module PopulateEnv
  module Heroku
    module_function

    def defaults
      OpenStruct.new(
        manifest: Pathname('app.json'),
        output: Pathname('.env'),
        heroku_app: nil,
        heroku_remote: nil,
        generate_secrets: true,
        use_local_env: true,
        use_heroku_config: true,
        prompt_missing: true
      )
    end

    def call(options)
      longest_key_length = options.to_h.keys.map(&:length).max

      options.each_pair do |key, value|
        puts "#{key.to_s.ljust(longest_key_length)}: #{value.inspect}"
      end

      puts
      abort "Command not implemented"
    end
  end
end
