dataset<-read.csv("Kickstarter_Complete_Cleaned.csv")
names(dataset)
table(dataset$state)
View(dataset)

failed<-subset(dataset, currency == 'USD' & state=="failed")
View(failed)
table(failed$currency)

failed_final<-failed
failed_final$backers<-as.numeric(as.character(failed$backers))
failed_final$goal<-as.numeric(as.character(failed$goal))

#finding mean and median backers
mean_backers<-mean(failed_final$backers, na.rm=TRUE)
median_backers<-median(failed_final$backers, na.rm=TRUE)


#finding mean and median pledged amounts
cat_pledged_mean<-aggregate(failed_final$pledged, by=list(category=failed_final$main_category), FUN=mean,
                              na.rm = TRUE)
cat_pledged_med<-aggregate(failed_final$pledged, by=list(category=failed_final$main_category), FUN=median,
                             na.rm = TRUE)

#finding mean and median goal
cat_goal_mean<-aggregate(failed_final$goal, by=list(category=failed_final$main_category), 
                           FUN=mean, na.rm = TRUE)
cat_goal_median<-aggregate(failed_final$goal, by=list(category=failed_final$main_category), 
                         FUN=median, na.rm = TRUE)

#finding mean and median backers
cat_backers_mean<-aggregate(failed_final$backers, by=list(category=failed_final$main_category), 
                              FUN=mean, na.rm = TRUE)

cat_backers_med<-aggregate(failed_final$backers, by=list(category=successfulUSD3$main_category), 
                             FUN=median, na.rm = TRUE)






