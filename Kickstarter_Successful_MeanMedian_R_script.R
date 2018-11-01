# This was the Kickstart_Complete_Cleaned.csv file that Owen uploaded to the repository on 10.18.18
kickstarter <- read.csv("/users/Janice/Documents/Grad school 2018/INFM600/Team project/Kickstarter_Complete_Cleaned.csv")

# looking at only successful campaigns

successfulCampaigns <- subset(kickstarter,state=="successful")

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

# plotting work - Outliers? Y-axis on Mean Pledged plot?

plot(meanPledgedByCat$Category, meanPledgedByCat$MeanPledged, type = "p")

plot(medianPledgedByCat$Category, medianPledgedByCat$MedianPledged, type = "p")


plot(meanBackersByCat$Category, meanBackersByCat$MeanBackers, type = "p")

plot(medianBackersByCat$Category, medianBackersByCat$MedianBackers, type = "p")


plot(meanGoalByCat$Category, meanGoalByCat$MeanGoal, type = "p")

plot(medianGoalByCat$Category, medianGoalByCat$MedianGoal, type = "p")
