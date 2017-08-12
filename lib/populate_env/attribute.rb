require 'delegate'

module PopulateEnv
  class Attribute < SimpleDelegator
    def initialize(definition, value)
      @value = value
      super(definition)
    end

    def value
      @value
    end
  end
end
