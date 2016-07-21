require_relative 'sensor'
require_relative 'actuator'

sensor = ControlTheory::Sensor.new
actuator = ControlTheory::Actuator.new

class Controller
  def initialize(target = 0.73603, k_p=-97.736, k_i=0.0,operating_point = 69.362)
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

#controller = Controller.new 0.7, -96.0
controller = Controller.new 0.7, -96.0, -0.5

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
