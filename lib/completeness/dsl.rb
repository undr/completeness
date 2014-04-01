module Completeness
  class DSL
    def initialize(options = {}, &block)
      @default_options = options
      instance_eval(&block)
    end

    def field(name, options = {})
      spec[name] = Field.new(spec, name, default_options.merge(options))
    end

    def spec
      @spec ||= Specification.new
    end

    private
    attr_reader :default_options
  end
end
