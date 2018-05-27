require 'json'

require 'net/http'
require 'uri'

module ControlTheory
  class Sensor
    def initialize(pods=nil, metrics=nil)
      @pods = pods || Pods.new
      @metrics = metrics || Metrics.new(@pods)
    end

    def utilization
      request = @pods.cpu_request.to_f
      @metrics.cpu_usage.to_f / request
    end
  end

  class Pods
    def cpu_request
      running_pods.inject(0) do |sum, pod| 
        pod['spec']['containers'].inject(sum) do |s, container|
          s + container['resources']['requests']['cpu'].to_i
        end
      end
    end

    def list_names
      running_pods.map do |pod|
        pod['metadata']['name']
      end
    end

    def running_pods
      api_call.select do |pod|
        pod['status']['phase'] == 'Running'
      end
    end

    def api_call
      return @api_call if @api_call
      # Hard-wired selector from the replication_controller
      endpoint = URI.parse 'http://127.0.0.1:8001/api/v1'\
                           '/namespaces/default/pods'

      http = Net::HTTP.new endpoint.host, endpoint.port

      response = http.request(Net::HTTP::Get.new endpoint.request_uri).body
      JSON.parse(response)['items']
    end
  end

  class Metrics
    def initialize(pods=nil)
      @pods = pods
    end

    def cpu_usage
      monitored_pods = api_call
      running_pods = @pods.list_names
      monitored_pods.inject(0) do |sum, pod|
        if running_pods.include? pod['metadata']['name']
          pod['containers'].inject(sum) do |s, container|
            sum += container['usage']['cpu'].to_i 
          end 
        else
          sum
        end
      end
    end

    def api_call
      # Hardwired Metrics API
      endpoint = URI.parse 'http://127.0.0.1:8001/apis/metrics.k8s.io/v1beta1'\
                           '/namespaces/default/pods'


      http = Net::HTTP.new endpoint.host, endpoint.port

      response = http.request(Net::HTTP::Get.new endpoint.request_uri).body
      JSON.parse(response)['items']
    end
  end
end
