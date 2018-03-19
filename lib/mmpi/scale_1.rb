module Mmpi
  class Scale_1 < Scale
    def concise_interpretation
      result = []
      if (45..55).cover?(t_grade) && all_t_grades_without_self_in(45.55)
        result.push(Scale.conclusions[:Scale_1][:linear_profile])
      end
      if all_t_grades_in(0..50) && all_t_grades.sort[0..2].all? { |t_grade| t_grade < 45 }
        result.push(Scale.conclusions[:Scale_1][:lower_profile])
      end
      l_diff = @scales[Scale_l].t_grade - @scales[Scale_f].t_grade
      k_diff = @scales[Scale_k].t_grade - @scales[Scale_f].t_grade
      if all_t_grades_in(0..55) &&
         ((@scales[Scale_l].t_grade > 60 && @scales[Scale_k].t_grade > 60) ||
         (l_diff > 7 && k_diff > 7))
        result.push(Scale.conclusions[:Scale_1][:lower_profile])
      end
      if (60..69).cover?(t_grade) && all_t_grades_without_self_in(60..65)
        result.push(Scale.conclusions[:Scale_1][:lead])
      end
      result.push(*interpretations_by_range)
    end
  end
end
