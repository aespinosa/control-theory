require_relative 'sensor'

require 'minitest/autorun'

class IntegrationTest < Minitest::Test
  include ControlTheory

  def test_pods
    pods = Pods.new
    assert_equal 400, pods.cpu_request
  end

  def test_heapster
    pods = Pods.new
    heapster = Heapster.new pods

    assert_equal 0, heapster.cpu_usage
  end
end
