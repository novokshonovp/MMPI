require 'yaml'
module Mmpi
  class Scale
    Dir['./lib/mmpi/scale_*.rb'].each { |file| require file }

    SUPPORTED_SCALES = [Scale_q, Scale_l, Scale_f, Scale_k, Scale_1, Scale_2,
                        Scale_3, Scale_4, Scale_5, Scale_6, Scale_7, Scale_8,
                        Scale_9, Scale_0].freeze
    attr_accessor :scale_k_value
    def initialize(keys, answers, gender)
      @scale_k_value = 0
      @answers = answers
      @gender = gender
      @keys = (keys["#{self.class.to_sym}_#{gender}".to_sym] || keys[self.class.to_sym])
      raise "No keys for #{self.class.to_sym}, gender: #{gender}" if @keys.nil?
    end

    def t_grade
      median = Consts::AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:median]
      sigma = Consts::AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:sigma]
      (50 + (10 * (co_corrected_with_k.to_f - median) / sigma)).round
    end

    def concise_interpretation
      return if self.class.concises.nil?
      concise = self.class.concises.detect { |range, _value| (range.cover?(t_grade)) }
      raise "#{Consts::PATH_TO_CONCISE} damaged !!!" if concise.nil?
      concise.last
    end

    def self.to_sym
      name.split('::').last.to_sym
    end

    def inspect
      "#<#{self.class.name}:#{object_id}, co: (#{co})"
    end

    def scale_k_value(scale_k)
      @scale_k_value = scale_k.co
    end

    def co
      significant_answers
    end

    private

    def self.concises
      @concises ||= YAML.load_file(Consts::PATH_TO_CONCISE)[to_sym]
    end

    def co_corrected_with_k
      co + (@scale_k_value.to_f * (k_correction || 0)).round
    end

    def significant_answers
      true_count = (@answers.select { |_q_num, answer| answer == true }.keys & @keys[:true])
                   .count
      false_count = (@answers.select { |_q_num, answer| answer == false }.keys & @keys[:false])
                    .count
      dnk_count = (@answers.select { |_q_num, answer| answer == 'dnk' }.keys & @keys[:dnk].to_a)
                    .count
      true_count + false_count + dnk_count
    end

    def k_correction
      Consts::CORRECTIONS[self.class.to_sym]
    end
  end
end
