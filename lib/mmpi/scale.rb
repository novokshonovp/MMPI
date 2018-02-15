require_relative 'consts'
module Mmpi
  class Scale
    Dir['./lib/mmpi/scale_*.rb'].each { |file| require file }

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
      @scale_k_value = scale_k.send('co')
    end

    private

    def co
      significant_answers
    end

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
      true_count + false_count
    end

    def k_correction
      Consts::CORRECTIONS[self.class.to_sym]
    end
  end
end
