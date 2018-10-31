Kickstarter_Complete_Cleaned <- read.csv("~/Kickstarter_Timeseries/Kickstarter_Complete_Cleaned.csv")

drop_cols <- names(Kickstarter_Complete_Cleaned) %in% c("name", "country", "deadline", "usd.pledged")

data <- Kickstarter_Complete_Cleaned[!drop_cols]

data$launched <- as.Date(data$launched, format = "%m/%d/%Y" )

install.packages("ggplot2")

data$launched_year <- format(data$launched,"%Y")

data$launched_month <- format(data$launched, "%B")

success_fail_subset <- subset(data, state=='successful' | state=='failed')

success_subset <- subset(data, state=='successful')

failed_subset <- subset(data, state == 'failed')

all_aggr_data = aggregate(success_fail_subset$state, by=list(Category = data$launched_year), FUN=length)

success_aggr = aggregate(success_subset$state, by=list(Category = success_subset$launched_year), FUN=length)

failed_aggr = aggregate(failed_subset$state, by=list(Category = failed_subset$launched_year), FUN=length)

plot(aggr_data$Category, aggr_data$x, type = "l")

plot(success_aggr$category, success_aggr$x, type = "l")

plot(failed_aggr$Category, failed_aggr$x, type = "l")


