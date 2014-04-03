require 'spec_helper'

describe Completeness::Field do
  describe '#required?' do
    subject{ Completeness::Field.new(nil, :name) }

    specify{ expect(subject.required?).to be_false }

    context 'when :required equals to nil' do
      subject{ Completeness::Field.new(nil, :name, required: nil) }
      specify{ expect(subject.required?).to be_false }
    end

    context 'when :required equals to false' do
      subject{ Completeness::Field.new(nil, :name, required: false) }
      specify{ expect(subject.required?).to be_false }
    end

    context 'when :required equals to true' do
      subject{ Completeness::Field.new(nil, :name, required: true) }
      specify{ expect(subject.required?).to be_true }
    end

    context 'when :required equals to some object' do
      subject{ Completeness::Field.new(nil, :name, required: '') }
      specify{ expect(subject.required?).to be_true }
    end
  end

  describe '#completed?' do
    let(:object){ double(:object, name: name) }
    let(:options){ {} }

    subject{ Completeness::Field.new(nil, :name, options) }

    context 'with default behavior' do
      context 'when value is nil' do
        let(:name){ nil }
        specify{ expect(subject.completed?(object)).to  be_false }
      end

      context 'when value is blank object' do
        let(:name){ '' }
        specify{ expect(subject.completed?(object)).to  be_false }
      end

      context 'when value is present object' do
        let(:name){ 'object' }
        specify{ expect(subject.completed?(object)).to  be_true }
      end
    end

    context 'with passed completeness check' do
      let(:options){ { check: ->(o, v){
        expect(o).to eq(object)
        expect(v).to eq(name)
        !v.nil?
      } } }

      context 'when value is nil' do
        let(:name){ nil }
        specify{ expect(subject.completed?(object)).to  be_false }
      end

      context 'when value is blank object' do
        let(:name){ '' }
        specify{ expect(subject.completed?(object)).to  be_true }
      end

      context 'when value is present object' do
        let(:name){ 'object' }
        specify{ expect(subject.completed?(object)).to  be_true }
      end
    end
  end

  describe '#weight' do
    let(:options){ { weight: 120 } }

    subject{ Completeness::Field.new(nil, :name, options) }

    specify{ expect(subject.weight).to eq(120) }

    context 'with default behavior' do
      let(:options){ {} }
      specify{ expect(subject.weight).to eq(Completeness::Field::DEFAULT_WEIGHT) }
    end
  end

  describe '#<=>' do
    let(:other){ Completeness::Field.new(nil, :other, options) }

    subject{ Completeness::Field.new(nil, :name) }

    context 'when other is required field' do
      let(:options){ { required: true } }
      specify{ expect(subject <=> other).to eq(-1) }
    end

    context 'when other is required field and its weight less than first' do
      let(:options){ { required: true, weight: 5 } }
      specify{ expect(subject <=> other).to eq(-1) }
    end

    context 'when other is required field and its weight more than first' do
      let(:options){ { required: true, weight: 15 } }
      specify{ expect(subject <=> other).to eq(-1) }
    end

    context 'when other is not required field' do
      let(:options){ {} }
      specify{ expect(subject <=> other).to eq(0) }
    end

    context 'when other is not required field and its weight less than first' do
      let(:options){ { weight: 5 } }
      specify{ expect(subject <=> other).to eq(1) }
    end

    context 'when other is not required field and its weight more than first' do
      let(:options){ { weight: 15 } }
      specify{ expect(subject <=> other).to eq(-1) }
    end
  end

  describe '#weight_in_percent' do
    let(:spec){ double(:spec, total_weight: 200) }

    subject{ Completeness::Field.new(spec, :name) }

    specify{ expect(subject.weight_in_percent).to eq(5) }
  end
end
