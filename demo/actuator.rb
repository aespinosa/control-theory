require 'net/http'

module ControlTheory
  class Actuator
    def initialize
    end

    def scale(instances=1)
      cf "scale demo -i #{instances}"
    end

    def cf(args)
      system "/nix/store/y43lfg6nrh9fy2ndxr7gsa08fwrl61jf-cf-6.35.2/bin/cf #{args}"
    end
  end
end
