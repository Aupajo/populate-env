module PopulateEnv
  module MissingPrompt
    module_function

    def call(definition, options)
      prompt = ''
      prompt << "\n  #{definition.description}\n\n" if definition.description
      prompt << "  => Please provide a value for #{definition.name}: "

      options.output.print prompt

      options.input.gets.strip
    end
  end
end
