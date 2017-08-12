module PopulateEnv
  module Heroku
    module_function

    def call(options)
      Compilation.new(options).perform
    end
  end
end
