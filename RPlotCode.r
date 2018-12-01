#_____ Calling all libraries _____#

install.packages("ggplot2")

library(ggplot2)
library(reshape2)

#______ Starting with the cleaned file (12 Nov 2018) ______ #

Kickstarter_Complete_Cleaned <- read.csv("C:\\Users\\Owen\\Downloads\\ks-projects-201801.csv")


#_____ Owen Henry _____#

drop_cols <- names(Kickstarter_Complete_Cleaned) %in% c("name", "country", "deadline", "usd.pledged")

datasetFull <- Kickstarter_Complete_Cleaned[!drop_cols]

#_____ Exclude outliers (pledge, backers, goal) using 1.5xIQR rule _____#
# reference: https://www.khanacademy.org/math/statistics-probability/summarizing-quantitative-data/box-whisker-plots/a/identifying-outliers-iqr-rule 

class(datasetFull$pledged)
class(datasetFull$goal)
class(datasetFull$backers)

# Ensure values are numeric for pledged, goal, and backers

datasetFull2 <- datasetFull
datasetFull2$pledged <- as.numeric(as.character(datasetFull$pledged))

datasetFull3 <- datasetFull
datasetFull3$goal <- as.numeric(as.character(datasetFull2$goal))

datasetFull4 <- datasetFull3
datasetFull4$backers <- as.numeric(as.character(datasetFull3$backers))

# Find and exclude outliers for pledged 
medianPledged <- median(datasetFull4$pledged, na.rm = TRUE) 
bottomHalfPledged <- subset(datasetFull4, datasetFull4$pledged < medianPledged)
Q1pledged <- median(bottomHalfPledged$pledged)
topHalfPledged <- subset(datasetFull4, datasetFull4$pledged > medianPledged)
Q3pledged <- median(topHalfPledged$pledged)
IQRpledged <- Q3pledged - Q1pledged
lowPledged <- subset(datasetFull4, datasetFull4$pledged < (Q1pledged - (1.5 * IQRpledged))) # there were 0 matching
highPledged <- subset(datasetFull4, datasetFull4$pledged > (Q3pledged + (1.5 * IQRpledged)))
highPledged_min = min(highPledged$pledged)
datasetFull5 <- subset(datasetFull4, pledged < highPledged_min)

# outliersPledged <- c(lowPledged, highPledged) # suspect this may cause an issue if 0 lowPledged
# datasetFull4 <- datasetFull4[!outliersPledged] # Error in !outliersPledged : invalid argument type
# datasetFull4 <- datasetFull4[!highPledged] # error for this, too: In Ops.factor(left) : '!' not meaningful for factors


### Find and exclude outliers for goal ### NEED TO FIX SOMETHING WITH THE lowGoal_max
medianGoal <- median(datasetFull5$goal, na.rm = TRUE) 
bottomHalfGoal <- subset(datasetFull5, datasetFull5$goal < medianGoal)
Q1goal <- median(bottomHalfGoal$goal)
topHalfGoal <- subset(datasetFull5, datasetFull5$goal > medianGoal)
Q3goal <- median(topHalfGoal$goal)
IQRgoal <- Q3goal - Q1goal
lowGoal <- subset(datasetFull5, datasetFull5$goal < (Q1goal - (1.5 * IQRgoal))) 
lowGoal_max = max(lowGoal$goal) # warning: In max(lowGoal$goal) : no non-missing arguments to max; returning -Inf
highGoal <- subset(datasetFull5, datasetFull5$goal > (Q3goal + (1.5 * IQRgoal)))
highGoal_min = min(highGoal$goal)
datasetFull6 <- subset(datasetFull5, (datasetFull5$goal < highGoal_min) & (datasetFull5$goal > lowGoal_max))

### Find and exclude outliers for backers ### NEED TO FIX SOMETHING WITH THE lowBackers_max AND highBackers_min

medianBackers <- median(datasetFull6$backers, na.rm = TRUE) 
bottomHalfBackers <- subset(datasetFull6, datasetFull6$backers < medianBackers)
Q1backers <- median(bottomHalfBackers$backers)
topHalfBackers <- subset(datasetFull6, datasetFull6$backers < medianBackers)
Q3backers <- median(topHalfGoal$goal)
IQRbackers <- Q3backers - Q1backers
lowBackers <- subset(datasetFull6, datasetFull6$backers < (Q1backers - (1.5 * IQRbackers))) 
lowBackers_max = max(lowBackers$backers) # warning: In max(lowBackers$backers) :  no non-missing arguments to max; returning -Inf
highBackers <- subset(datasetFull6, datasetFull6$backers > (Q3backers + (1.5 * IQRbackers))) 
highBackers_min = min(highBackers$backers) # warning: In min(highBackers$backers) : no non-missing arguments to min; returning Inf
datasetFull7 <- subset(datasetFull6, (datasetFull6$backers < highBackers_min) & (datasetFull6$backers > lowBackers_max)) # right now, datasetFull7 is the same as datasetFull6

# dataset excluding outliers to be used for rest of script

dataset <- datasetFull7

#_____ Vyjayanthi Kamath _____#

names(dataset)
table(dataset$state)
View(dataset)


#_____ Time Series Analysis - Owen Henry _____# 

dataset$launched <- as.Date(dataset$launched, format = "%m/%d/%Y" )

dataset$launched_year <- format(dataset$launched,"%Y")

dataset$launched_year

dataset <- subset(dataset, dataset$launched_year != 2018)

dataset$launched_month <- format(dataset$launched, "%B")

success_subset <- subset(dataset, state=='successful')

failed_subset <- subset(dataset, state != 'successful')

all_aggr_data = aggregate(dataset$state, by=list(Category = dataset$launched_year), FUN=length)

success_aggr = aggregate(success_subset$state, by=list(Category = success_subset$launched_year), FUN=length)

failed_aggr = aggregate(failed_subset$state, by=list(Category = failed_subset$launched_year), FUN=length)

class(all_aggr_data)

all_aggr_data$successful = as.numeric(as.character(success_aggr$x))

all_aggr_data$failed = as.numeric(as.character(failed_aggr$x))


colnames(all_aggr_data)[2] <- 'All'

all_aggr_data

#_____ Successful Campaigns Analysis - Janice Chan ______#

# looking at only successful campaigns

successfulCampaigns <- subset(dataset,state=="successful")

# below is on successful campaigns where currency is USD, answering 3 initial questions

successfulUSD <- subset(successfulCampaigns,currency=="USD")

# work on pledged for all
meanPledgedSuccessfulUSD <- mean(successfulUSD$pledged, na.rm = TRUE)
medianPledgedSuccessfulUSD <- median(successfulUSD$pledged, na.rm = TRUE)

# clean up of backers + work on all backers - DID NOT EXCLUDE THOSE WITH 0 BACKERS, COME BACK TO THIS
class(successfulUSD$backers)
successfulUSD2 <- successfulUSD
successfulUSD2$backers <- as.numeric(as.character(successfulUSD$backers))
meanBackersSuccessfulUSD <- mean(successfulUSD2$backers, na.rm = TRUE)
medianBackersSuccessfulUSD <- median(successfulUSD2$backers, na.rm = TRUE)

# clean up of goal + work on all goals
class(successfulUSD$goal)
successfulUSD3 <- successfulUSD2
successfulUSD3$goal <- as.numeric(as.character(successfulUSD2$goal))
meanGoalSuccessfulUSD <- mean(successfulUSD3$goal, na.rm = TRUE) # There are some goals set to 0.01 - should we include them?
medianGoalSuccessfulUSD <- median(successfulUSD3$goal, na.rm = TRUE)


# by categories
meanPledgedByCat <- aggregate(successfulUSD3$pledged, by=list(category=successfulUSD3$main_category), FUN=mean, na.rm = TRUE)
colnames(meanPledgedByCat) <- c("Category", "MeanPledged")
meanPledgedByCat

medianPledgedByCat <- aggregate(successfulUSD3$pledged, by=list(category=successfulUSD3$main_category), FUN=median, na.rm = TRUE)
colnames(medianPledgedByCat) <- c("Category", "MedianPledged")
medianPledgedByCat

meanBackersByCat <- aggregate(successfulUSD3$backers, by=list(category=successfulUSD3$main_category), FUN=mean, na.rm = TRUE)
colnames(meanBackersByCat) <- c("Category", "MeanBackers")
meanBackersByCat

medianBackersByCat <- aggregate(successfulUSD3$backers, by=list(category=successfulUSD3$main_category), FUN=median, na.rm = TRUE)
colnames(medianBackersByCat) <- c("Category", "MedianBackers")
medianBackersByCat

meanGoalByCat <- aggregate(successfulUSD3$goal, by=list(category=successfulUSD3$main_category), FUN=mean, na.rm = TRUE)
colnames(meanGoalByCat) <- c("Category", "MeanGoal")
meanGoalByCat

medianGoalByCat <- aggregate(successfulUSD3$goal, by=list(category=successfulUSD3$main_category), FUN=median, na.rm = TRUE)
colnames(medianGoalByCat) <- c("Category", "MedianGoal")
medianGoalByCat


#______ Failed Campaigns Analysis - Vyjayanthi Kamath _____#

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
class(all_aggr_data$Category)

#_____ ALL PLOTS GO HERE _____#

#This plots Owen's data on successful vs. failed vs. all kickstarters over time

df = melt(all_aggr_data, id=c("Category"))

ggplot(df) + 
  geom_line(aes(x=Category, y=value, colour = variable, group = variable)) + 
  scale_colour_manual(values = c("red", "blue", "green"))

ggplot( x = all_aggr_data$Category, y = all_aggr_data$x, xlab = 'Year', ylab = 'Total Kickstarters', main = "Count of Kickstarters Over Time" )
#plot above still in progress and may need some restructuring/reformatting of dataframes since we had previously worked independently on script portions

ggplot(data = medianPledgedByCat, aes(x=Category, y=MedianPledged)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data = meanBackersByCat, aes(x=Category, y=MeanBackers)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data = medianBackersByCat, aes(x=Category, y=MedianBackers)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data = meanGoalByCat, aes(x=Category, y=MeanGoal)) +
  geom_bar(stat="identity") + coord_flip()

ggplot(data = medianGoalByCat, aes(x=Category, y=MedianGoal)) +
  geom_bar(stat="identity") + coord_flip()
  
 
