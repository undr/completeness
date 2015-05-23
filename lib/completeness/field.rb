module Completeness
  class Field
    DEFAULT_WEIGHT = 10

    attr_reader :spec, :name, :options

    def initialize(spec, name, options = {})
      @spec = spec
      @name = name
      @options = options
    end

    def required?
      !!options[:required]
    end

    def completed?(object)
      value = object.respond_to?(name) ? object.send(name) : nil
      completeness_check.call(object, value)
    end

    def weight
      options[:weight] || DEFAULT_WEIGHT
    end

    def <=>(other)
      return 1 if required? && !other.required?
      return -1 if !required? && other.required?
      weight <=> other.weight
    end

    def weight_in_percent
      (weight / (spec.total_weight / 100.0)).round
    end

    def completeness_check

      if options[:check].present? && options[:check].respond_to?(:call)
        options[:check]
      else
        ->(obj, value){ value.present? }
      end
    end
  end
end
