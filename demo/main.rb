require_relative 'sensor'
require_relative 'actuator'

sensor = ControlTheory::Sensor.new
actuator = ControlTheory::Actuator.new

class Controller
  def initialize(target = 0.50, k_p=-10.0, k_i=0.0, k_d = 0.0)
    @k_p = k_p
    @target = target.to_f
  end

  def work(actual)
    error = @target - actual
    puts "Error #{error}"

    (@k_p * error).ceil
  end
end

controller = Controller.new

while true do
  output = sensor.utilization

  instances = controller.work output


  actuator.scale(instances + 6)
  puts "Time: #{Time.now} Input: #{instances} Output: #{output}"
  sleep 5
end
