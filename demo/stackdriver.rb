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

require 'json'

def cf(args)
  `/nix/store/y43lfg6nrh9fy2ndxr7gsa08fwrl61jf-cf-6.35.2/bin/cf #{args}`
end

raw = JSON.parse cf 'curl /v2/apps/f5585fea-3257-40c5-a43b-862d4e8ad878/stats'
instances =  raw.count

instance_data = data.dup
instance_data['points'][0]['value']['int64_value'] = instances

client.create_time_series project, [instance_data]

require 'time'

raw.each do |index, usage|
  usage = usage['stats']['usage']
  cpu_data = data.dup
  cpu_data['metric']['type'] = 'custom.googleapis.com/cloudfoundry/cpu'
  cpu_data['metric']['labels']['index'] = index
  cpu_data['points'][0].tap do |point|
    point['interval']['end_time'] = Time.parse usage['time']
    point['value']['double_value'] = usage['cpu']
  end
  client.create_time_series project, [cpu_data]
end
