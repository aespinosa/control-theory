require 'net/http'

module ControlTheory
  class Actuator
    def initialize
      @endpoint = URI.parse 'http://127.0.0.1:8001/api/v1/namespaces/default'\
        '/replicationcontrollers/app'
      @http = Net::HTTP.new @endpoint.host, @endpoint.port
    end

    def scale(replicas=1)
      request = Net::HTTP::Patch.new @endpoint.request_uri
      request.body = {'spec' => { 'replicas' => replicas } }.to_json
      request['Content-Type'] = 'application/strategic-merge-patch+json'

      @http.request request
    end
  end
end
