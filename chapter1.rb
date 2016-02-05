require 'minitest/autorun'

class Buffer
  def initialize(max_wip, max_flow)
    @ready_pool = 0
    @downstream_buffer = 0

    @max_wip = max_wip
    @max_flow = max_flow
  end

  def work(u)
    u = [0, u.round].max
    u = [u, @max_wip].min
    @ready_pool += u

    t = (rand * @ready_pool).round
    @ready_pool -= t
    @downstream_buffer += t

    r = (rand * @max_flow).round
    r = [r, @downstream_buffer].min
    @downstream_buffer -= r
    @downstream_buffer
  end
end

class OpenLoop < Minitest::Test
  def buffer
    @buffer ||= Buffer.new 50, 10
  end

  def f
    @f ||= File.open(name, 'w')
  end

  def teardown
    @f.close
  end

  def test_inflow_is_equal_to_mean_outflow
    1.upto 5000 do |t|
      u = 5.0 # mean(uniform(0,10))
      y = buffer.work u
      f.puts [t, u, 0, u, y].join ' '
    end
  end

  def test_inflow_is_slightly_bigger_than_mean_outflow
    1.upto 5000 do |t|
      u = 5.1 # mean(uniform(0,10)) * 1.02
      y = buffer.work u
      f.puts [t, u, 0, u, y].join ' '
    end
  end
end
