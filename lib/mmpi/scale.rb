module Mmpi
  class Scale
    require_relative 'scale_l'
    require_relative 'scale_f'
    require_relative 'scale_k'
    require_relative 'scale_1'
    require_relative 'scale_2'
    require_relative 'scale_3'
    require_relative 'scale_4'
    require_relative 'scale_5'
    require_relative 'scale_6'
    require_relative 'scale_7'
    require_relative 'scale_8'
    require_relative 'scale_9'
    require_relative 'scale_0'
    PATH_TO_CONCISE = './data/concise_interpretation.yaml'.freeze
    CORRECTIONS = { Scale_1: 0.5, Scale_4: 0.4, Scale_7: 1, Scale_8: 1, Scale_9: 0.2 }.freeze
    AVERAGE_DEVIATIONS = { male: { Scale_l: { median: 4.2, sigma: 2.9 },
                                  Scale_f: { median: 2.76, sigma: 4.67 },
                                  Scale_k: { median: 12.1, sigma: 5.4 },
                                  Scale_1: { median: 11.1, sigma: 3.9 },
                                  Scale_2: { median: 16.6, sigma: 4.11 },
                                  Scale_3: { median: 16.46, sigma: 5.4 },
                                  Scale_4: { median: 18.68, sigma: 4.11 },
                                  Scale_5: { median: 20.46, sigma: 5.0 },
                                  Scale_6: { median: 7.9, sigma: 3.4 },
                                  Scale_7: { median: 23.06, sigma: 5.0 },
                                  Scale_8: { median: 21.96, sigma: 5.0 },
                                  Scale_9: { median: 17.0, sigma: 4.06 },
                                  Scale_0: { median: 25.0, sigma: 10.0 } },
                           female: {
                             Scale_l: { median: 4.2, sigma: 2.9 },
                             Scale_f: { median: 2.76, sigma: 4.67 },
                             Scale_k: { median: 12.1, sigma: 5.4 },
                             Scale_1: { median: 12.9, sigma: 4.83 },
                             Scale_2: { median: 18.9, sigma: 5.0 },
                             Scale_3: { median: 18.66, sigma: 5.38 },
                             Scale_4: { median: 18.68, sigma: 4.11 },
                             Scale_5: { median: 36.7, sigma: 4.67 },
                             Scale_6: { median: 7.9, sigma: 3.4 },
                             Scale_7: { median: 25.07, sigma: 6.1 },
                             Scale_8: { median: 22.73, sigma: 6.36 },
                             Scale_9: { median: 17.0, sigma: 4.06 },
                             Scale_0: { median: 25.0, sigma: 10.0 }
                           } }.freeze
    attr_accessor :scale_k_value
    def initialize(keys, answers, gender)
      @scale_k_value = 0
      @answers = answers
      @gender = gender
      @keys = (keys["#{self.class.to_sym}_#{gender}".to_sym] || keys[self.class.to_sym])
      raise "No keys for #{self.class.to_sym}, gender: #{gender}" if @keys.nil?
    end

    def t_grade
      median = AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:median]
      sigma = AVERAGE_DEVIATIONS[@gender][self.class.to_sym][:sigma]
      (50 + (10 * (co_corrected_with_k.to_f - median) / sigma)).round
    end

    def concise_interpretation
      return if self.class.concises.nil?
      concise = self.class.concises.detect { |range, _value| (range.cover?(t_grade)) }
      raise "#{PATH_TO_CONCISE} damaged !!!" if concise.nil?
      concise.last
    end

    def self.to_sym
      name.split('::').last.to_sym
    end

    def inspect
      "#<#{self.class.name}:#{object_id}, co: (#{co})"
    end
      
    def scale_k_value(scale_k)
      @scale_k_value = scale_k.send('co')
    end

    private

    def co
      significant_answers
    end

    def self.concises
      @concises ||= YAML.load_file('./data/concise_interpretation.yaml')[to_sym]
    end

    def co_corrected_with_k
      co + (@scale_k_value.to_f * (k_correction || 0)).round
    end

    def significant_answers
      true_count = (@answers.select { |_q_num, answer| answer == true }.keys & @keys[:true])
                   .count
      false_count = (@answers.select { |_q_num, answer| answer == false }.keys & @keys[:false])
                    .count
      true_count + false_count
    end

    def k_correction
      CORRECTIONS[self.class.to_sym]
    end
  end
end
