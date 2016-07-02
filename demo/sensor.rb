require 'json'

require 'net/http'
require 'uri'

module ControlTheory
  class Sensor
    def initialize(pods=nil, heapster=nil)
      @pods = pods || Pods.new
      @heapster = heapster || Heapster.new(@pods)
    end

    def utilization
      request = @pods.cpu_request.to_f
      @heapster.cpu_usage.to_f / request
    end
  end

  class Pods
    def cpu_request
      @api_call = nil
      pods = api_call

      pods.inject(0) do |sum, pod| 
        pod['spec']['containers'].inject(sum) do |s, container|
          s + container['resources']['requests']['cpu'].to_i
        end
      end
    end

    def list_names
      pods = api_call
      pods.map do |pod|
        pod['metadata']['name']
      end
    end

    def api_call
      return @api_call if @api_call
      # Hard-wired selector from the replication_controller
      endpoint = URI.parse 'http://127.0.0.1:8001/api/v1'\
                           '/namespaces/default/pods?labelSelector=name=app'

      http = Net::HTTP.new endpoint.host, endpoint.port

      response = http.request(Net::HTTP::Get.new endpoint.request_uri).body
      JSON.parse(response)['items']
    end
  end

  class Heapster
    def initialize(pods=nil)
      @pods = pods
    end

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

    def api_call
      pods = @pods.list_names.join(',')

      endpoint = URI.parse 'http://127.0.0.1:8001/api/v1/proxy'\
                           '/namespaces/kube-system/services/heapster'\
                           '/api/v1/model/namespaces/default'\
                           "/pod-list/#{pods}/metrics/cpu-usage"

      http = Net::HTTP.new endpoint.host, endpoint.port

      response = http.request(Net::HTTP::Get.new endpoint.request_uri).body
      JSON.parse(response)['items']
    end
  end
end
