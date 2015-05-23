require 'spec_helper'

describe Completeness::DSL do
  describe '#field' do
    let(:dsl){ Completeness::DSL.new(options){} }

    subject{ dsl.spec.attributes[:name] }

    before{ dsl.field(:name, weight: 15) }

    context 'without global options' do
      let(:options){ {} }

      it "have global options" do
        expect(subject.name).to be == :name
        expect(subject.options).to be == {weight: 15}
        expect(subject.spec).to be == dsl.spec
      end
    end

    context 'with global options' do
      let(:options){ { required: true, weight: 20 } }
      it "override global options" do
        expect(subject.name).to be == :name
        expect(subject.options).to be == {required: true, weight: 15}
        expect(subject.spec).to be == dsl.spec
      end
    end
  end
end