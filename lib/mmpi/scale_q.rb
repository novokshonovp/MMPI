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
    
  end
end
