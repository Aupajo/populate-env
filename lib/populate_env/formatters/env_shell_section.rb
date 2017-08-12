module PopulateEnv
  module Formatters
    class EnvShellSection
      attr_reader :attribute

      def initialize(attribute)
        @attribute = attribute
      end

      def to_s
        output = ''
        
        if attribute.description
          attribute.description.each_line do |line|
            output << "# #{line}\n"
          end
        end
        
        if attribute.optional? && attribute.value.nil?
          output << "# "
        end
        
        output << "#{attribute.name}=#{attribute.value}\n"
      end
    end
  end
end
