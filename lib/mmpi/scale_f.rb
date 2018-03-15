module Mmpi
  class Scale_f < Scale
    def concise_interpretation
      result = 'Шкала "F": '
      result << case t_grade
                when 65..75
                  'прохождение теста в состояние дискомфорта.'
                when 75..Float::INFINITY
                  'данные теста недостоверны.'
                else
                  ''
                end
      result
    end

    def reliable?
      t_grade <= 75 ? true : false
    end

  end
end
