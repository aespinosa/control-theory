install.packages('reshape')
library(reshape)

raw<-read.csv("data-model.raw", header=FALSE, sep = " ")
names(raw)<-c("var", "value", "time")
data<-cast(raw, time ~ var)
names(data)<-c("time", "y", "u")
N<-nrow(data)-1
mean_u<-mean(data[1:N,]$u)
mean_y<-mean(data[2:(N+1),]$y)
rms_data<-data.frame(time = data[1:N,]$time, uk = data[1:N,]$u, yk = data[1:N,]$y, yk1 = data[2:(N+1),]$y)

model<-lm(yk1 ~ yk + uk, rms_data)

plot(rms_data$yk1 + mean_y, rms_data$uk + mean_u, xlab = "Number of Replicas", ylab="CPU Utilization")
