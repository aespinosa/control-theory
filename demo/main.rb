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
controller = Controller.new 260.0, -0.1, 0.0, 70.0

require 'socket'

while true do
  output = sensor.utilization

  instances = controller.work output

  actuator.scale instances
  now = Time.now.to_i
  TCPSocket.open 'graphite.dev', '2003' do |graphite|
    graphite.puts "demo.replication_controller.replicas #{instances} #{now}"
    puts "demo.replication_controller.replicas #{instances} #{now}"
    graphite.puts "demo.pods.cpu_utilization #{output} #{now}"
    puts "demo.pods.cpu_utilization #{output} #{now}"
  end
  sleep 5
end
