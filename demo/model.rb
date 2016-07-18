require_relative 'sensor'
require_relative 'actuator'

sensor = ControlTheory::Sensor.new
actuator = ControlTheory::Actuator.new

class Controller

  def initialize(start)
    @start = start
  end

  def at(time)
    (30 * Math.sin((time - @start) * Math::PI / 600.0) + 70).ceil
  end
end

require 'socket'
start = Time.now.to_i - 3000
controller = Controller.new start


while true do
  now = Time.now.to_i
  
  output = sensor.utilization

  instances = controller.at now
  actuator.scale instances

  TCPSocket.open 'graphite.dev', '2003' do |graphite|
    graphite.puts "demo.replication_controller.replicas #{instances} #{now}"
    puts "demo.replication_controller.replicas #{instances} #{now}"
    graphite.puts "demo.pods.cpu_utilization #{output} #{now}"
    puts "demo.pods.cpu_utilization #{output} #{now}"
  end
  sleep 5
end
