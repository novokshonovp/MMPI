module Answers
  def self.all_truth
    fill_with(true)
  end
  def self.all_false
    fill_with(false)
  end
  private

  def self.fill_with(value)
    (1..566).each_with_object([]) { |index, obj| obj.push([index, value]) }.to_h
  end
end
