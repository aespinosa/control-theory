require_relative 'sensor'

require 'minitest/autorun'

class ControlTheory::Pods
  private
  def api_call
    JSON.parse(File.read 'pods.json')['items']
  end
end

class ControlTheory::Heapster
  private
  def api_call
    JSON.parse(File.read 'cpu.json')['items']
  end
end

class SensorTest < Minitest::Test
  include ControlTheory

  def test_something_something
    sensor = Sensor.new
    assert_equal 0.3875, sensor.utilization
  end

  def test_pods
    pods = Pods.new

    assert_equal 400, pods.cpu_request
  end

  def test_heapster_stable
    heapster = Heapster.new
    
    assert_equal 155, heapster.cpu_usage
  end
end
