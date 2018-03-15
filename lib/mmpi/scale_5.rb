module Mmpi
  class Scale_5 < Scale
    def t_grade
      case @gender
      when :male
        forward_grade
      when :female
        backward_grade
      end
    end
  end
end
