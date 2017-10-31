require 'optparse'
require 'populate_env/version'
require 'populate_env/cli/runner'
require 'populate_env/cli/heroku_options'

module PopulateEnv
  module CLI
    module_function

    def start(*args)
      Runner.new(*args).run
    end
  end
end
