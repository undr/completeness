require 'spec_helper'

describe Completeness::Specification do
  let(:name1_value){ nil }
  let(:name2_value){ nil }
  let(:name3_value){ nil }
  let(:object){ double(:object, name1: name1_value, name2: name2_value, name3: name3_value) }

  subject{ Completeness::Specification.new }

  describe '#[]' do
    before{ subject.stub(attributes: { name1: 'name1', name2: 'name2' }) }

    specify{ expect(subject[:name1]).to eq('name1') }
    specify{ expect(subject[:name2]).to eq('name2') }
  end

  describe '#[]=' do
    specify{ expect{ subject[:name1] = 'name1' }.to change{subject[:name1]}.from(nil).to('name1') }
  end

  describe '#required_attributes' do
    let(:name1){ Completeness::Field.new(subject, :name1, required: true) }
    let(:name2){ Completeness::Field.new(subject, :name2, required: false) }
    let(:name3){ Completeness::Field.new(subject, :name3, required: true) }

    before do
      subject[:name1] = name1
      subject[:name2] = name2
      subject[:name3] = name3
    end

    specify{ expect(subject.required_attributes).to eq([name1, name3]) }
  end

  describe '#total_weight' do
    before do
      subject[:name1] = Completeness::Field.new(subject, :name1, weight: 12)
      subject[:name2] = Completeness::Field.new(subject, :name2, weight: 13)
      subject[:name3] = Completeness::Field.new(subject, :name3, weight: 14)
    end

    specify{ expect(subject.total_weight).to eq(39) }
  end

  describe '#recomend_next_attribute_for' do
    let(:name1){ Completeness::Field.new(subject, :name1, required: true) }
    let(:name2){ Completeness::Field.new(subject, :name2, required: false, weight: 15) }
    let(:name3){ Completeness::Field.new(subject, :name3, required: true, weight: 5) }

    before do
      subject[:name1] = name1
      subject[:name2] = name2
      subject[:name3] = name3
    end

    specify{ expect(subject.recomend_next_attribute_for(object)).to eq(name1) }

    context do
      let(:name1_value){ 'value' }
      specify{ expect(subject.recomend_next_attribute_for(object)).to eq(name3) }
    end

    context do
      let(:name1_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.recomend_next_attribute_for(object)).to eq(name2) }
    end

    context do
      let(:name1_value){ 'value' }
      let(:name2_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.recomend_next_attribute_for(object)).to be_nil }
    end
  end

  describe '#weighted_uncompleted_attributes_for' do
    let(:name1){ Completeness::Field.new(subject, :name1, required: true) }
    let(:name2){ Completeness::Field.new(subject, :name2, required: false, weight: 15) }
    let(:name3){ Completeness::Field.new(subject, :name3, required: true, weight: 5) }

    before do
      subject[:name1] = name1
      subject[:name2] = name2
      subject[:name3] = name3
    end

    specify{ expect(subject.weighted_uncompleted_attributes_for(object)).to eq([name1, name3, name2]) }

    context do
      let(:name1_value){ 'value' }
      specify{ expect(subject.weighted_uncompleted_attributes_for(object)).to eq([name3, name2]) }
    end

    context do
      let(:name1_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.weighted_uncompleted_attributes_for(object)).to eq([name2]) }
    end

    context do
      let(:name1_value){ 'value' }
      let(:name2_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.weighted_uncompleted_attributes_for(object)).to be_empty }
    end
  end

  describe '#completed_weight' do
    before do
      subject[:name1] = Completeness::Field.new(subject, :name1, weight: 5)
      subject[:name2] = Completeness::Field.new(subject, :name2, weight: 10)
      subject[:name3] = Completeness::Field.new(subject, :name3, weight: 15)
    end

    specify{ expect(subject.completed_weight(object)).to eq(0) }

    context 'when one attribute is completed' do
      let(:name1_value){ 'value' }
      specify{ expect(subject.completed_weight(object)).to eq(5) }
    end

    context 'when another attribute is completed' do
      let(:name2_value){ 'value' }
      specify{ expect(subject.completed_weight(object)).to eq(10) }
    end

    context 'when two attributes are completed' do
      let(:name1_value){ 'value' }
      let(:name2_value){ 'value' }
      specify{ expect(subject.completed_weight(object)).to eq(15) }
    end

    context 'when all attributes are completed' do
      let(:name1_value){ 'value' }
      let(:name2_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.completed_weight(object)).to eq(30) }
    end
  end

  describe '#completed_percent' do
    before do
      subject[:name1] = Completeness::Field.new(subject, :name1, weight: 5)
      subject[:name2] = Completeness::Field.new(subject, :name2, weight: 10)
      subject[:name3] = Completeness::Field.new(subject, :name3, weight: 15)
    end

    specify{ expect(subject.completed_percent(object)).to eq(0) }

    context 'when one attribute is completed' do
      let(:name1_value){ 'value' }
      specify{ expect(subject.completed_percent(object)).to eq(17) }
    end

    context 'when another attribute is completed' do
      let(:name2_value){ 'value' }
      specify{ expect(subject.completed_percent(object)).to eq(33) }
    end

    context 'when two attributes are completed' do
      let(:name1_value){ 'value' }
      let(:name2_value){ 'value' }
      specify{ expect(subject.completed_percent(object)).to eq(50) }
    end

    context 'when all attributes are completed' do
      let(:name1_value){ 'value' }
      let(:name2_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.completed_percent(object)).to eq(100) }
    end
  end

  describe '#completed?' do
    before do
      subject[:name1] = Completeness::Field.new(subject, :name1, required: true)
      subject[:name2] = Completeness::Field.new(subject, :name2, required: false)
      subject[:name3] = Completeness::Field.new(subject, :name3, required: true)
    end

    specify{ expect(subject.completed?(object)).to be == false }

    context 'when one required attribute is completed' do
      let(:name1_value){ 'value' }
      specify{ expect(subject.completed?(object)).to be == false }
    end

    context 'when one unrequired attribute is completed' do
      let(:name2_value){ 'value' }
      specify{ expect(subject.completed?(object)).to be == false }
    end

    context 'when all required attributes are completed' do
      let(:name1_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.completed?(object)).to be == true }
    end

    context 'when all attributes are completed' do
      let(:name1_value){ 'value' }
      let(:name2_value){ 'value' }
      let(:name3_value){ 'value' }
      specify{ expect(subject.completed?(object)).to be == true }
    end
  end
end
