require 'spec_helper'

describe Completeness::DSL do
  describe '#field' do
    let(:dsl){ Completeness::DSL.new(options){} }

    subject{ dsl.spec.attributes[:name] }

    before{ dsl.field(:name, weight: 15) }

    context 'without global options' do
      let(:options){ {} }

      its(:name){ should eq(:name) }
      its(:options){ should eq(weight: 15) }
      its(:spec){ should eq(dsl.spec) }
    end

    context 'with global options' do
      let(:options){ { required: true, weight: 20 } }

      its(:name){ should eq(:name) }
      its(:options){ should eq(required: true, weight: 15) }
      its(:spec){ should eq(dsl.spec) }
    end
  end
end
