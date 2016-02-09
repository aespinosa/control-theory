require_relative 'test_helper'

require 'minitest/autorun'

class CacheHit < Minitest::Test
  include Plotter

  def cache(size)
    if size < 0
      hitrate = 0
    elsif size > 100
      hitrate = 1
    else
      hitrate = size / 100.0
    end
  end

  def test_cache_set_on_error
    reference_hitrate = 0.6
    actual_hitrate = 0.0
    cumulative_error = 0.0

    k = 175.0

    200.times do 
      error = reference_hitrate - actual_hitrate
      cumulative_error += error
      cache_size = k * cumulative_error
      actual_hitrate = cache cache_size
      f.puts [reference_hitrate, error, cumulative_error,
              cache_size, actual_hitrate].join ' '
    end
  end
end
