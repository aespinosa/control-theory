# DevOpsDays Minneapolis

Talk outline

## Introduction

Bio and stuff

## Feedback

What does it mean when you operationalize your app?

Typical Ops feedback loop (Page 3): <http://espinosa.io/control-theory/sketches.pdf>

## Feedback in a Thermostat

Notice how it looks the same (without the Pager!)

<http://espinosa.io/control-theory/sketch2.pdf>

## Feedback Principle

* Compare the output to its desired reference value. 
* *apply change* to input that counteracts deviations of the output to the
  reference value.

Ops example:
> * you get paged for server load
> * you add instances
> * you go back to sleep

## Autoscaling

* desired reference value - your Ops target
* current value - reports from your monitoring system
* input - number of instances

## What makes a good feedback loop?

* Stabiliy 
* Performance
* Accuracy

Page 3 & 4 of <http://espinosa.io/control-theory/sketches.pdf>

## Ways to correct errors

* Proportional - error multiplied by a constant
* Integral - total error accumulated over time
* Differential - change in the error previously

Make analogies on how that looks like in an AWS Autoscaling policy

## Demo

* webapp deployed on Kubernetes
* load generator
* some monitoring
* Autoscaler/ controller making Kubernetes API calls

It should look something like `Out[5]` in <http://espinosa.io/control-theory/chapter13.html>.

## End

References:

* Janert, *Feedback Control for Computer Systems* <http://amzn.com/1449361692>
* Hellerstein et. al., *Feedback Control of Computing Systems* <http://amzn.com/047126637X>
