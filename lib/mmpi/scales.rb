require_relative 'scale'
Dir['./lib/mmpi/scale_*.rb'].each { |file| require file }
