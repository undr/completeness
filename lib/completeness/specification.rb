module Completeness
  class Specification
    attr_reader :attributes

    def initialize
      @attributes = {}
    end

    def [](key)
      attributes[key]
    end

    def []=(key, value)
      attributes[key] = value
    end

    def all_attributes
      @all_attributes ||= attributes.values
    end

    def required_attributes
      all_attributes.select(&:required?)
    end

    def total_weight
      all_attributes.sum(&:weight)
    end

    def recomend_next_attribute_for(object)
      weighted_uncompleted_attributes_for(object).first
    end

    def weighted_uncompleted_attributes_for(object)
      uncompleted_attributes_for(object).sort.reverse
    end

    def completed_weight(object)
      completed_attributes_for(object).sum(&:weight)
    end

    def completed_percent(object)
      (completed_weight(object) / (total_weight / 100.0)).round
    end

    def completed?(object)
      required_attributes.all?{|attribute| attribute.completed?(object)}
    end

    private

    def completed_attributes_for(object)
      all_attributes.select{|attribute| attribute.completed?(object) }
    end

    def uncompleted_attributes_for(object)
      all_attributes.reject{|attribute| attribute.completed?(object) }
    end
  end
end
