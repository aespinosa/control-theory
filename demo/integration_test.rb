require_relative 'sensor'
require_relative 'actuator'

require 'minitest/autorun'

class IntegrationTest < Minitest::Test
  include ControlTheory

  def test_pods
    pods = Pods.new
    assert_equal 400, pods.cpu_request
  end

  def test_metrics
    pods = Pods.new
    heapster = Metrics.new pods

    assert_equal 0, heapster.cpu_usage
  end

  def test_actuator
    actuator = Actuator.new

    assert_equal nil, actuator.scale(3)
  end
end
