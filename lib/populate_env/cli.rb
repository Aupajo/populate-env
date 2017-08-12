require 'populate_env/version'
require 'populate_env/cli/runner'

module PopulateEnv
  module CLI
    module_function
    
    def start(*args)
      Runner.new(*args).run
    end
  end
end
