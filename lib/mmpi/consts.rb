module Consts
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
    CORRECTIONS = { Scale_1: 0.5, Scale_4: 0.4, Scale_7: 1, Scale_8: 1, Scale_9: 0.2 }.freeze
    PATH_TO_CONCISE = './data/concise_interpretation.yaml'.freeze
    PATH_TO_KEYS = './data/key_scales.yaml'.freeze
    PATH_TO_GRAPH_TEMPLATES = './data/graph_templates.yaml'.freeze
end
