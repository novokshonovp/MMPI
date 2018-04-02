require 'yaml'
module Mmpi
  class Scale
    require_relative 'scales'
    SUPPORTED_SCALES = [Scale_q, Scale_l, Scale_f, Scale_k, Scale_1, Scale_2,
                        Scale_3, Scale_4, Scale_5, Scale_6, Scale_7, Scale_8,
                        Scale_9, Scale_0].freeze
    BASE_SCALES = [Scale_1, Scale_2, Scale_3, Scale_4, Scale_5, Scale_6, Scale_7,
                   Scale_8, Scale_9, Scale_0].freeze
    def initialize(scales, keys, answers, gender)
      @scales = scales
      @answers = answers
      @gender = gender
      @keys = (keys["#{self.class.to_sym}_#{gender}".to_sym] || keys[self.class.to_sym])
      raise "No keys for #{self.class.to_sym}, gender: #{gender}" if @keys.nil?
    end

    def t_grade
      forward_grade
    end

    def self.to_sym
      name.split('::').last.to_sym
    end

    def co
      significant_answers
    end

    def inspect
      "#<#{self.class.name}:#{object_id}, co: (#{co})"
    end

    def self.conclusions
      @conclusions ||= YAML.load_file(Consts::PATH_TO_CONCISE)
    end

    private

    def forward_grade
      median = Consts::AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:median]
      sigma = Consts::AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:sigma]
      (50 + (10 * (co_corrected_with_k.to_f - median) / sigma)).round
    end

    def backward_grade
      median = Consts::AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:median]
      sigma = Consts::AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:sigma]
      (50 + (10 * (co_corrected_with_k.to_f - median) / sigma).abs).round
    end

    def scale_k_value
      @scales[Scale_k].co
    end

    def co_corrected_with_k
      co + (scale_k_value.to_f * (k_correction || 0)).round
    end

    def significant_answers
      true_count = (@answers.select { |_q_num, answer| answer == true }.keys & @keys[:true])
                   .count
      false_count = (@answers.select { |_q_num, answer| answer == false }.keys & @keys[:false])
                    .count
      true_count + false_count
    end

    def k_correction
      Consts::CORRECTIONS[self.class.to_sym]
    end

    def base_scales
      @scales.select { |klass, _object| BASE_SCALES.include?(klass) }
    end

    def all_t_grades_without_self
      base_scales.reject { |klass, _object| klass == self.class }
                 .map { |_klass, object| object.t_grade }
    end

    def all_t_grades_without_self_in(range)
      all_t_grades_without_self.all? { |t_grade| range.cover?(t_grade) }
    end

    def all_t_grades
      base_scales.map { |_klass, object| object.t_grade }
    end

    def all_t_grades_in(range)
      all_t_grades.all? { |t_grade| range.cover?(t_grade) }
    end

    def interpretations_by_range
      raise 'Damaged conclusions file!' if Scale.conclusions[self.class.to_sym].nil?
      Scale.conclusions[self.class.to_sym][:ranges]
           .map { |range, data| [data] if range.cover?(t_grade) }
           .compact
    end
  end
end
