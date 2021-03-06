require 'simplecov'
SimpleCov.start
require_relative '../lib/mmpi'

include Mmpi
describe Test do
  context 'when men' do
    let(:test) { Test.new(:men, path_to_mmpi_men_csv) }
    let(:path_to_mmpi_men_csv) { './spec/fixtures/q_mmpi_men_ru.csv'}

    describe '#get_question' do
      let(:test) { Test.new(:men, './spec/fixtures/q_mmpi_men_ru_one_record.csv') }
      subject { test.get_question }
      it { is_expected.to eq ({number: '14', question:'Номер данного пункта следует обвести кружочком'}) }
    end

    describe '#put_answer' do
      before { test.put_answer(answer) }
      let(:answer) { { '14'=> true } }
      it { expect(test.quiz['14'][:answer]).to be true }
      it { expect(test.quiz['14'][:is_checked]).to be true }
    end

    describe '#finished?' do
      subject { test.finished? }
      context 'when false' do
        before { test.put_answer( {'14'=> true } ) }
        it { is_expected.to be false }
      end
      context 'when true' do
        before {
          test.put_answer( {'14'=> true })
          test.put_answer( {'15'=> true })
          test.put_answer( {'16'=> true })
        }
        it { is_expected.to be true }
      end
    end

    describe '#answers' do
      let(:test) { Test.new(:men, './spec/fixtures/q_mmpi_men_ru_one_record.csv') }
      before { test.put_answer(answer) }
      let(:answer) { { '14'=> true } }
      subject { test.answers }
      it { is_expected.to eq ( {14=>true} ) }
    end

    describe '#age' do  
      let(:test) { Test.new(:men, path_to_mmpi_men_csv, { age:'22'} ) }
      subject { test.age }
      it { is_expected.to eq('22 года') }
    end

  end
end
