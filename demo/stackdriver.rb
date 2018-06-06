require 'google/cloud/monitoring/v3'

client = Google::Cloud::Monitoring::V3::Metric.new

data = {
  'metric' => {
    'type' => 'custom.googleapis.com/cloudfoundry/instances',
    'labels' => { 'application' => 'demo' }
  },
  'resource' => {
    'type' => 'global',
    'labels' => {
      'project_id' => 'control-theory'
    }
  },
  'points' => [ {
    'interval' => {
      'end_time' => Time.now
    },
    'value' => { }
  } ]
}

project = Google::Cloud::Monitoring::V3::MetricServiceClient.project_path('control-theory')

# client.create_time_series project, [data]

require_relative 'sensor'

pods = ControlTheory::Pods.new
sensor = ControlTheory::Sensor.new

utilization =  sensor.utilization
instances =  pods.list_names.count

instance_data = data.dup
instance_data['points'][0]['value']['int64_value'] = instances

client.create_time_series project, [instance_data]

cpu_data = data.dup

puts utilization, instances

cpu_data['metric']['type'] = 'custom.googleapis.com/cloudfoundry/cpu'
cpu_data['points'][0]['value']['double_value'] = utilization
client.create_time_series project, [cpu_data]
