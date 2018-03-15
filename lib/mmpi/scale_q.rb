module Mmpi
  class Scale_q < Scale
    def concise_interpretation
      result = 'Шкала "?": '
      result << case co
                when 24..40
                  'допустимый результат.'
                when 41..60
                  'выраженная настороженность обследуемого.'
                else
                  'данные теста недостоверны.'
                end
      result
    end

    def reliable?
      co >= 24 && co <= 60 ? true : false
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
