require_relative 'result.rb'
require 'csv'

module Mmpi
  class Test
    DATA_STRUCTURE = %i[number question].freeze

    attr_reader :quiz, :gender, :additional_data
    def initialize(gender, path, additional_data= {firstname: 'anonymous', age: 20, grade: 'level_1'})
      @quiz = {}
      @gender = gender
      @additional_data = additional_data
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
      question = [unfinished.to_a.first].to_h.
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

    def answers
      @quiz.map { |key, value| [key.to_i,value[:answer]]}.to_h
    end

    def age
        return if @additional_data.nil?
        return if @additional_data[:age].nil?
        suffix = ''
        case (@additional_data[:age].to_i % 10)
          when 1
            suffix = 'год'
          when 2..4
            suffix = 'года'
          else
            suffix = 'лет'
        end
        "#{@additional_data[:age]} #{suffix}"
    end

    private

    def unfinished
      @quiz.select { |key,value| value[:is_checked]==false }
    end
  end
end
