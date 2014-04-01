module Completeness
  module Model
    extend ActiveSupport::Concern

    included do
      cattr_accessor :completeness_spec
    end

    module ClassMethods
      def completeness(options = {}, &block)
        self.completeness_spec = DSL.new(options, &block).spec
      end
    end

    def completeness_spec
      self.class.completeness_spec
    end

    def completed?
      completeness_spec.completed?(self)
    end

    def completed_percent
      completeness_spec.completed_percent(self)
    end

    def completed_weight
      completeness_spec.completed_weight(self)
    end
  end
end
