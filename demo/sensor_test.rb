require_relative 'sensor'

gem 'minitest'
require 'minitest/autorun'

class ControlTheory::Pods
  private
  def api_call
    JSON.parse(File.read 'pods.json')['items']
  end
end

class ControlTheory::Metrics
  private
  def api_call
    JSON.parse(File.read 'cpu.json')['items']
  end
end

class PodsTest < Minitest::Test
  include ControlTheory

  def test_list_only_running_pods
    pods = Pods.new
    assert_equal 2, pods.list_names.count
  end

  def test_pods_cpu_request
    pods = Pods.new

    assert_equal 1000, pods.cpu_request
  end

  def test_pod_names
    pods = Pods.new

    assert_equal %w(app-one app-two), pods.list_names
  end
end

class SensorTest < Minitest::Test
  include ControlTheory

  def test_metrics
    heapster = Metrics.new Pods.new
    
    assert_equal 900, heapster.cpu_usage
  end

  def test_grabs_utilization
    sensor = Sensor.new
    assert_equal 0.9, sensor.utilization
  end
end
