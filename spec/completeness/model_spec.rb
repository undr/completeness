require 'spec_helper'

describe Completeness::Model do
  shared_examples_for :delegated_methods do |*method_names|
    let(:object){ klass.new }
    let(:klass){ Class.new{
      include Completeness::Model
      completeness{}
    } }

    method_names.each do |method_name|
      specify do
        expect(object.completeness_spec).to receive(method_name).with(object)
        object.send(method_name)
      end
    end
  end

  describe '.completeness' do
    let(:block){ ->(o){} }
    let(:options){ {} }
    let(:dsl){ double(:dsl, spec: 'spec') }
    let(:klass){ Class.new{ include Completeness::Model } }

    before do
      expect(Completeness::DSL).to receive(:new).with(options, &block).and_return(dsl)
      klass.completeness(options, &block)
    end

    specify{ expect(klass.completeness_spec).to eq('spec') }
  end

  it_should_behave_like :delegated_methods, :completed?, :completed_percent, :completed_weight
end
