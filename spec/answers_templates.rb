module Answers
  def self.all_truth
    fill_with(true)
  end

  def self.all_false
    fill_with(false)
  end

  def self.reliable
    YAML.load_file('./spec/fixtures/reliable_answers.yaml').answers
  end

  private

  def self.fill_with(value)
    (1..566).each_with_object([]) { |index, obj| obj.push([index, value]) }.to_h
  end
end
