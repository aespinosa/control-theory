require 'json'

module ControlTheory
  class Sensor
    def initialize(pods=nil, heapster=nil)
      @pods = pods || Pods.new
      @heapster = heapster || Heapster.new
    end

    def utilization
      @heapster.cpu_usage.to_f / @pods.cpu_request.to_f
    end
  end

  class Pods
    def cpu_request
      pods = api_call

      pods.inject(0) do |sum, pod| 
        pod['spec']['containers'].inject(sum) do |s, container|
          s + container['resources']['requests']['cpu'].to_i
        end
      end
    end
  end

  class Heapster
    def cpu_usage
      pods = api_call
      pods.inject(0) do |sum, pod|
        timestamp = pod['latestTimestamp']
        pod['metrics'].inject(sum) do |s, metric|
          if metric['timestamp'] == timestamp
            s + metric['value']
          else
            s
          end
        end 
      end
    end
  end
end
