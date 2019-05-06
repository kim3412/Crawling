install.packages("taskscheduleR")
library(taskscheduleR)

taskscheduler_create(taskname = "give task name", 
                     rscript = "give R source's path to execute", 
                     schedule = "DAILY", starttime = "00:13", startdate = format(Sys.Date(), "%Y/%m/%d"))
