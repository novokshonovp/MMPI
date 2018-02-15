require_relative 'consts'
module Mmpi
  class Result

    attr_reader :scales
    def initialize(answers, gender)
      @answers = answers
      @keys = YAML.load_file(Consts::PATH_TO_KEYS)
      @scales = { Scale_l => nil, Scale_f => nil, Scale_k => nil,
                  Scale_1 => nil, Scale_2 => nil, Scale_3 => nil, Scale_4 => nil,
                  Scale_5 => nil, Scale_6 => nil, Scale_7 => nil, Scale_8 => nil,
                  Scale_9 => nil, Scale_0 => nil }
      @scales.each_key do |scale|
        scales[scale] = scale.new(@keys, answers, gender)
      end
      @scales.each_value { |object| object.scale_k_value(scales[Scale_k]) }
      @g_templates = YAML.load_file(Consts::PATH_TO_GRAPH_TEMPLATES)
    end
    def graph_parity
      @g_templates.each_with_object(Array.new) do | (profile, data), obj|
        overlap = data[:Scales].all? do |name, value|
          (value[:term]-value[:deviation_down]..value[:term]+value[:deviation_up])
            .cover?(@scales[eval(name.to_s)].t_grade)
        end

        obj.push([profile,data]) if overlap
      end
    end
    def graph_template(profile)
      @g_templates[profile][:Scales].map do |scale, values|
        [scale, values[:term]]
      end.to_h
    end
  end
end
