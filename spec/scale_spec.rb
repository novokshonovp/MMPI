require 'simplecov'
SimpleCov.start
require_relative '../lib/mmpi'
require 'yaml'

include Mmpi
describe Scale do
  before do
    scales.each { |scale, object| scales[scale] = scale.new(keys, answers, gender) }
    scales.values.each { |object| object.scale_k_value(scales[Scale_k]) }
  end
  let(:keys) { YAML.load_file('./spec/fixtures/key_scales.yaml') }
  let(:scales) { {Scale_l => nil,Scale_f => nil,Scale_k => nil,
            Scale_1 => nil,Scale_2 => nil,Scale_3 => nil,Scale_4 => nil,
            Scale_5 => nil,Scale_6 => nil,Scale_7 => nil,Scale_8 => nil,
            Scale_9 => nil,Scale_0 => nil } }
  describe '#t_grade' do
    context 'when Scale L' do
      let(:gender) { :male }
      context 'when all false' do
        let(:answers) { { 15=>false, 30=>false, 45=>false, 60=>false, 75=>false, 90=>false, 105=>false, 120=>false, 135=>false, 150=>false, 165=>false, 195=>false, 225=>false, 255=>false, 285=>false} }
        subject { scales[Scale_l].t_grade }
        it { is_expected.to eq 87 }
      end
      context 'when all true' do
        let(:answers) { { 15=>true, 30=>true, 45=>true, 60=>true, 75=>true, 90=>true, 105=>true, 120=>true, 135=>true, 150=>true, 165=>true, 195=>true, 225=>true, 255=>true, 285=>true} }
        subject { scales[Scale_l].t_grade }
        it { is_expected.to eq 36 }
      end
      context 'when 7 false' do
        let(:answers) { { 15=>false, 30=>false, 45=>false, 60=>false, 75=>false, 90=>false, 105=>false, 120=>true, 135=>true, 150=>true, 165=>true, 195=>true, 225=>true, 255=>true, 285=>true} }
        subject { scales[Scale_l].t_grade }
        it { is_expected.to eq 60 }
      end
    end
    context 'when Scale F' do
      let(:gender) { :male }
      context 'when all false' do
        let(:answers) { { 4=>false, 23=>false, 27=>false, 31=>false, 34=>false, 35=>false, 40=>false, 42=>false, 48=>false, 49=>false, 50=>false, 53=>false, 56=>false, 66=>false,
                          85=>false, 121=>false, 123=>false, 139=>false, 146=>false, 151=>false, 156=>false, 168=>false, 184=>false, 197=>false, 200=>false, 202=>false, 205=>false,
                          206=>false, 209=>false, 210=>false, 211=>false, 215=>false, 218=>false, 227=>false, 245=>false, 246=>false, 247=>false, 252=>false, 256=>false, 269=>false,
                          275=>false, 286=>false, 291=>false, 293=>false, 17=>false, 20=>false, 54=>false, 65=>false, 75=>false, 83=>false, 112=>false, 113=>false, 115=>false,
                          164=>false, 169=>false, 177=>false, 185=>false, 196=>false, 199=>false, 220=>false, 257=>false, 258=>false, 272=>false, 276=>false } }
        subject { scales[Scale_f].t_grade }
        it { is_expected.to eq 87 }
      end
      context 'when all true' do
        let(:answers) { { 4=>true,   23=>true,  27=>true,  31=>true,  34=>true,  35=>true,  40=>true,  42=>true,  48=>true,  49=>true,  50=>true,   53=>true, 56=>true,
                           66=>true,  85=>true, 121=>true, 123=>true, 139=>true, 146=>true, 151=>true, 156=>true, 168=>true, 184=>true, 197=>true, 200=>true, 202=>true,
                          205=>true, 206=>true, 209=>true, 210=>true, 211=>true, 215=>true, 218=>true, 227=>true, 245=>true, 246=>true, 247=>true, 252=>true, 256=>true,
                          269=>true, 275=>true, 286=>true, 291=>true, 293=>true,    17=>true, 20=>true, 54=>true, 65=>true, 75=>true, 83=>true, 112=>true, 113=>true, 115=>true,
                          164=>true, 169=>true, 177=>true, 185=>true, 196=>true, 199=>true, 220=>true, 257=>true, 258=>true, 272=>true, 276=>true } }
        subject { scales[Scale_f].t_grade }
        it { is_expected.to eq 138 }
      end
    end

    context 'when Scale K' do
      let(:gender) { :male }
      context 'when all false' do
        let(:answers) { { 96=>true,  30=>true,  39=>true,  71=>true,  89=>true, 124=>true, 129=>true, 134=>true, 138=>true, 142=>true, 148=>true, 160=>true,
                         170=>true, 171=>true, 180=>true, 183=>true, 217=>true, 234=>true, 267=>true, 272=>true, 296=>true,
                         316=>true, 322=>true, 374=>true, 383=>true, 397=>true, 398=>true, 406=>true, 461=>true, 502=> true} }
        subject { scales[Scale_k].t_grade }
        it { is_expected.to eq 29 }
      end
      context 'when all true' do
        let(:answers) { { 96=>false,  30=>false,  39=>false,  71=>false,  89=>false, 124=>false, 129=>false, 134=>false, 138=>false, 142=>false, 148=>false, 160=>false,
                         170=>false, 171=>false, 180=>false, 183=>false, 217=>false, 234=>false, 267=>false, 272=>false, 296=>false,
                         316=>false, 322=>false, 374=>false, 383=>false, 397=>false, 398=>false, 406=>false, 461=>false, 502=> false} }
        subject { scales[Scale_k].t_grade }
        it { is_expected.to eq 81 }
      end
    end
  end
end
