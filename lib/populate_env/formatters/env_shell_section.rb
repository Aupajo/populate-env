module PopulateEnv
  module Formatters
    class EnvShellSection
      attr_reader :attribute, :export

      def initialize(attribute, export: false)
        @attribute = attribute
        @export = export
      end

      def prefix
        export ? "export " : ""
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
        
        output << "#{prefix}#{attribute.name}=#{attribute.value}\n"
      end
    end
  end
end
