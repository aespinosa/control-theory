require_relative 'sensor'
require_relative 'actuator'

sensor = ControlTheory::Sensor.new
actuator = ControlTheory::Actuator.new

class Controller
  def initialize(target, k_p, k_i, operating_point)
    @k_p = k_p
    @k_i = k_i
    @target = target.to_f
    @operating_point = operating_point
    @total_error = 0.0
  end

  def work(actual)
    error = @target - actual
    puts "Error #{error}"
    @total_error += error

    (@k_p * error + @k_i * @total_error + @operating_point).ceil
  end
end

# u[k] = -0.1 * e[k]
controller = Controller.new 0.30, -100.0, 0.0, 40

require 'socket'

while true do
  output = sensor.utilization

  instances = controller.work output

  actuator.scale instances
  now = Time.now.to_i
  puts "instances #{instances} #{now}"
  puts "cpu_usage #{output} #{now}"
  # Sampling interval
  sleep 5
end
