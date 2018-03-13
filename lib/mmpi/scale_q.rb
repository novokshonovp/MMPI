module Mmpi
  class Scale_q < Scale

    def concise_interpretation
      super(co)
    end

    def is_reliable?
      co > 70 ? false : true
    end

    def t_grade
      0
    end
    def significant_answers
      (@answers.select { |_q_num, answer| answer == 'dnk' }.keys & @keys[:dnk].to_a)
               .count
    end
  end
end
