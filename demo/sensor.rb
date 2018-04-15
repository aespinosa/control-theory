require 'json'

module ControlTheory
  class Sensor
    def initialize(app=nil, cf=CloudFoundry.new)
      @app = app
      @cf = cf
    end

    def utilization
      data = @cf.api_call
      instances = 0.0
      total_usage = 0.0
      total_usage = data.reduce(0) do |sum, details|
        if details[1]['state'] == 'RUNNING'
          instances += 1.0
          sum += details[1]['stats']['usage']['cpu']
        end
        sum
      end
      puts total_usage
      total_usage / instances
    end
  end

  class CloudFoundry
    def api_call
      JSON.parse cf 'curl /v2/apps/f5585fea-3257-40c5-a43b-862d4e8ad878/stats'
    end

    private
    def cf(args)
      `/nix/store/y43lfg6nrh9fy2ndxr7gsa08fwrl61jf-cf-6.35.2/bin/cf #{args}`
    end
  end
end
