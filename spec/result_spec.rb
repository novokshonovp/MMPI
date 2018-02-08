require 'simplecov'
SimpleCov.start
require_relative '../lib/mmpi'
require 'yaml'

include Mmpi
describe Result do
  let(:result) { Result.new(answers, :men) }
  let(:answers) { { 15=>false, 30=>false, 45=>false, 60=>false, 75=>false, 90=>false, 105=>false, 120=>false, 135=>false, 150=>false, 165=>false, 195=>false, 225=>false, 255=>false, 285=>false} }
end
