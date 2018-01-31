require_relative 'result.rb'
require 'csv'

module Mmpi
  class Test
    DATA_STRUCTURE = %i[number question].freeze

    attr_reader :quiz
    def initialize(gender, path)
      @quiz = {}
      @gender = gender
      file = File.open(path).read
      @quiz = CSV.parse(file, col_sep: '|', headers: DATA_STRUCTURE)
                   .map do |quiz_fizture|
                     [quiz_fizture[:number],
                     { 'ques': quiz_fizture[:question], 'answer':nil,
                       is_checked: false }]
                   end.to_h
    end

    def get_question
      return nil if finished?
      question = [unfinished.to_a.sample].to_h.
                  map{ |key, value| [key,value[:ques]]}.first
      {number: question.first, question: question.last}
    end
    def put_answer(answer)
      @quiz[answer.keys.first][:answer] = answer.values.first
      @quiz[answer.keys.first][:is_checked] = true
      self
    end
    def finished?
      @quiz.all?{|key,value| value[:is_checked]==true }
    end
    def render
      return nil if !finished?
      Result.new
    end

    private

    def unfinished
      @quiz.select { |key,value| value[:is_checked]==false }
    end
  end
end
