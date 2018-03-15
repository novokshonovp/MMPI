module Mmpi
  class Scale_l < Scale
    def concise_interpretation
      super(t_grade)
    end

    def reliable?
      t_grade > 70 ? false : true
    end
  end
end
