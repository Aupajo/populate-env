module PopulateEnv
  class AttributeDefinition
    attr_reader :name, :default, :generator, :description

    def initialize(name:, default: nil, generator: nil, description: nil, required: true)
      @name = name.to_s.upcase
      @default = default
      @generator = generator
      @description = description
      @required = required
    end

    def required?
      @required
    end

    def optional?
      !required?
    end
  end
end
