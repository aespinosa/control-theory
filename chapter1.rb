require_relative 'test_helper'

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

module Defaults
  def buffer
    @buffer ||= Buffer.new 50, 10
  end
end

class OpenLoop < Minitest::Test
  include Defaults
  include Plotter

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

class Controller
  def initialize(kp, ki)
    @proportional = kp
    @integral = ki

    @cumulative_error = 0
  end

  def work(error)
    @cumulative_error += error

    @proportional * error + @integral * @cumulative_error
  end
end

class ClosedLoopd < Minitest::Test
  include Defaults
  include Plotter

  def reference(t)
    if t < 100
      0
    elsif t < 300
      50
    else
      10
    end
  end

  def test_proportional
    controller = Controller.new 2.0, 0

    y = 0
    1.upto 5000 do |t|
      r = reference(t)
      e = r - y
      u = controller.work e
      y = buffer.work u
      f.puts [t, r, e, u, y].join(' ')
    end
  end
end
