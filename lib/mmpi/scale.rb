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
    CORRECTIONS = { Scale_1: 0.5, Scale_4: 0.4, Scale_7: 1, Scale_8: 1, Scale_9: 0.2  }
    def initialize(scale, keys, answers, gender)
      @scale = scale
      @answers=answers
      @keys = (keys["#{self.class.to_sym}_#{gender}".to_sym] || keys[self.class.to_sym])
      raise "No keys for #{self.class.to_sym}, gender: #{gender}" if @keys.nil?
    end

    def co
      significant_answers
    end

    def co_corrected_with_k(scale_k_value)
      co + ((scale_k_value.to_f) * (k_correction || 0) ).round
    end

    def self.to_sym
      self.name.split('::').last.to_sym
    end

    def inspect
      "#<#{self.class.name}:#{self.object_id}, co: (#{co})"
    end

    private
    def significant_answers
      true_count = (@answers.select{|q_num, answer| answer==true}.keys & @keys[:true]).count
      false_count = (@answers.select{|q_num, answer| answer==false}.keys & @keys[:false]).count
      true_count + false_count
    end
    def k_correction
      CORRECTIONS[self.class.to_sym]
    end
  end
end
