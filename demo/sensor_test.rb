require_relative 'sensor'

gem 'minitest'
require 'minitest/autorun'

class ControlTheory::CloudFoundry
  def api_call
    JSON.parse(File.read 'cf.json')
  end
end

class SensorTest < Minitest::Test
  include ControlTheory

  def test_something_something
    sensor = Sensor.new
    assert_equal 0.4, sensor.utilization
  end

end
