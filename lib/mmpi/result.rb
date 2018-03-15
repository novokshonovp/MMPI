require_relative 'scale'
require 'yaml'
module Mmpi
  class Result
    attr_reader :scales
    def initialize(answers, gender)
      @answers = answers
      @keys = YAML.load_file(Consts::PATH_TO_KEYS)
      @scales = Scale::SUPPORTED_SCALES.map { |klass| [klass, nil] }.to_h
      @scales.each_key do |scale|
        scales[scale] = scale.new(@scales, @keys, answers, gender)
      end
      @g_templates = YAML.load_file(Consts::PATH_TO_GRAPH_TEMPLATES)
    end

    def graph_parity
      @g_templates.each_with_object([]) do |(profile, data), obj|
        overlap = data[:Scales].all? do |name, value|
          (value[:term] - value[:deviation_down]..value[:term] + value[:deviation_up])
            .cover?(@scales[eval(name.to_s)].t_grade)
        end

        obj.push([profile, data]) if overlap
      end
    end

    def graph_template(profile)
      @g_templates[profile][:Scales].map do |scale, values|
        [scale, values[:term]]
      end.to_h
    end

    def reliable?
      return false if welsh_index.abs > 11
      !@scales.any? { |_klass, scale|  scale.reliable? == false if scale.respond_to?('reliable?') }
    end

    def welsh_index
      @scales[Scale_f].co - @scales[Scale_k].co
    end
  end
end
