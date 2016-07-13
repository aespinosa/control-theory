# Simple Autoscaler

There's three parts on an autoscaler:

* Controller - the one that decides how much to scale
* Actuator - the one that does the actual scaling. In this case, it's just simple PATCH requests to the ReplicationController
* Sensor - the one that gives the controller feedback if it is being effective in autoscaling
