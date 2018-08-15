require_relative 'sensor'
require_relative 'actuator'

sensor = ControlTheory::Sensor.new
actuator = ControlTheory::Actuator.new

class Controller
  def initialize(target, k_p, k_i, operating_point)
    @k_p = k_p
    @k_i = k_i
    @target = target.to_f # r[k]
    @operating_point = operating_point
    @total_error = 0.0
  end

  def work(actual)
    error = @target - actual # e[k]
    @total_error += error
    puts "Error: #{error} Total: #{@total_error}"
    puts "u(t): #{@k_p * error} Total: #{@k_i * @total_error}"

    (@k_p * error + @k_i * @total_error + @operating_point).ceil
  end
end

# u[k] = -60.0 * e[k] + -30.0 ∑e[k] + 55.0
#                           r[k]  K_p    K_i    u[k]
controller = Controller.new 0.55, -60.0, -30.0, 55.0

while true do
  output = sensor.utilization # y[k]

  instances = controller.work output # u[k]
  actuator.scale instances

  puts output
  puts instances
  sleep 120
end
