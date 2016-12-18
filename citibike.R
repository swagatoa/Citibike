#citibike data transformation using data tables
# refer to this stackoverflow post for more
#http://stackoverflow.com/questions/34665073/speed-up-for-loop-on-a-large-dataset/41145819#41145819
library(data.table)
bikedata<-fread('201609-citibike-tripdata.csv')
colnames(bikedata)<-make.names(colnames(bikedata))

# find out which bikes were moved by operators from one station to other by operators vs riders
bikedata[,c("end.station.id",
            "diff.time",
            "stoptime",
            "starttime") :=
           list(shift(end.station.id,1L,type="lag"),
                as.double(difftime(strptime(starttime, 
                                            "%m/%d/%Y %H:%M:%S"),
                                   strptime(shift(stoptime,1L,type="lag"), 
                                            "%m/%d/%Y %H:%M:%S")
                                   ,units = "mins")),
                as.character(shift(stoptime,1L,type="lag")),
                as.character(starttime)
           ),
         by=bikeid]



bikedatamoved<-bikedata[!is.na(end.station.id)&(end.station.id!=start.station.id)]


bikedatamoved[,
              setdiff(colnames(bikedatamoved),c("bikeid","end.station.id",
                                                "start.station.id",
                                                "diff.time",
                                                "stoptime",
                                                "starttime")):=NULL]

setcolorder(bikedatamoved, c("bikeid", 
                             "end.station.id", 
                             "start.station.id",        
                             "diff.time",           
                             "stoptime",          
                             "starttime"))

