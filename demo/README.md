# Simple Autoscaler

There's three parts on an autoscaler:

* Controller - the one that decides how much to scale
* Actuator - the one that does the actual scaling. In this case, it's just simple PATCH requests to the ReplicationController
* Sensor - the one that gives the controller feedback if it is being effective in autoscaling

## Running the Demo

Deploy the following components in Kubernetes:

* `replication_controller.yml` - the application to be scaled
* `service.yml` - service definition of the application
* `vegata.yml` - the load generator

The autoscaler is currently hardwired to the components above and heapster in localhost. So you need to run `kubectl proxy`

Finally run the autoscaler with `ruby main.rb`
