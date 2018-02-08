module Mmpi
  class Result
    PATH_TO_KEYS = './data/key_scales.yaml'.freeze
    attr_reader :scales
    def initialize(answers, gender)
      @answers = answers
      @keys = YAML.load_file(PATH_TO_KEYS)
      @scales = { Scale_l => nil, Scale_f => nil, Scale_k => nil,
                  Scale_1 => nil, Scale_2 => nil, Scale_3 => nil, Scale_4 => nil,
                  Scale_5 => nil, Scale_6 => nil, Scale_7 => nil, Scale_8 => nil,
                  Scale_9 => nil, Scale_0 => nil }
      @scales.each_key do |scale|
        scales[scale] = scale.new(@keys, answers, gender)
      end
      @scales.each_value { |object| object.scale_k_value(scales[Scale_k]) }
    end
  end
end
