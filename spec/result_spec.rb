require 'simplecov'
SimpleCov.start
require_relative '../lib/mmpi'
require 'answers_templates'
require 'yaml'

include Mmpi
describe Result do
  let(:result) { Result.new(answers, :male) }
  let(:answers) { Answers.all_truth }
  describe '#graph_parity' do
    subject { result.graph_parity }
    context 'when all truth' do
      it { expect(subject[0][0]).to eq(:profile_1) }
    end
    context 'when all false' do
      let(:answers) {Answers.all_false}
      it { expect(subject[0][0]).to eq(:profile_2) }
    end
  end
  describe 'graph_template' do
    subject { result.graph_template(type) }
    context 'when sthenic type' do
      let(:type) { :profile_response_1 }
      it { is_expected.to eq({:Scale_l=>50, :Scale_f=>45, :Scale_k=>60, :Scale_1=>47, :Scale_2=>45, :Scale_3=>47, :Scale_4=>62, :Scale_5=>57, :Scale_6=>64, :Scale_7=>57, :Scale_8=>60, :Scale_9=>66, :Scale_0=>55}) }
    end
  end

  describe '#is_reliable' do
    subject { result.is_reliable? }
    context 'when reliable' do
      let(:answers) { Answers.reliable }
      it { is_expected.to be true }
    end
    context 'when not reliable' do
      let(:answers) { Answers.all_false }
      it { is_expected.to be false}
    end
  end
end
