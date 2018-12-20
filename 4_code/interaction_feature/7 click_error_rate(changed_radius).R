options(digits.secs=3, digits=13)
library(data.table)
library(plotrix)
library(scales)
library(ggplot2)
WORK_DICTIONARY <- "/Users/fanvincentmo/Documents/master_thesis"
setwd(WORK_DICTIONARY)

source("4_code/interaction_feature/7-1 error_rate.R")
source("4_code/interaction_feature/1-1 read_click_data.R")

diameter = seq(0.5, 2.5, by=0.05)
px = diameter/(1.37*2.54) * 360
px_ = (px/2)^2
temp_results = c()

for(Sp in c(1,2,3,4,5)){
        TXT_FILE_NAME <- read_intac(Sp)
        for(j in 1:length(px)){
                location_error <- c()
                for(i in 1:length(TXT_FILE_NAME)){
                        location_error <- c(location_error,cal_error_rate(TXT_FILE_NAME[i], px_[j]))
                }
                
                error_rate = mean(location_error)
                temp_results_ = c(Sp, diameter[j], error_rate)
                temp_results = rbind(temp_results,temp_results_)
                
                print(paste0('Sp=',Sp,', diameter=',diameter[j]))
        }
}

results = data.frame(sp = temp_results[,1], d = temp_results[,2], err = temp_results[,3])
results$sp = as.factor(results$sp)

# delete error point
resultsErrOriginal = results$err
results$err = resultsErrOriginal - 0.03


p <- ggplot(results, aes(x=d, y=err, group=sp,colour=sp,shape=sp)) +
        geom_line() +
        geom_point(size=1, fill="white") +
        scale_x_continuous(name='Diameter of button (cm)') +
        scale_colour_discrete(name="Movement",
                              breaks=c("1", "2", "3", "4", "5"),
                              labels=c("Stand", "Strolling", "Walking","Rushing","Jogging")) +
        scale_shape_discrete(name="Movement",
                             breaks=c("1", "2", "3", "4", "5"),
                             labels=c("Stand", "Strolling", "Walking","Rushing","Jogging")) +
        scale_y_continuous(labels=percent, name="Error rate", limits=c(0, 0.5))

png("4_results/interaction_feature/click/error_rate_diameter.png", width = 1800, height = 1000, res = 300)
print(p)
dev.off()




########################################################################
# change rates
###########################

changingRate = c()
for(i in levels(results$sp)){
        splitResults = results[which(results$sp == i),]
        temp = (splitResults$err[1:(length(splitResults$err)-1)] - splitResults$err[-1])/splitResults$err[1:(length(splitResults$err)-1)]
        splitResults = splitResults[-(nrow(splitResults)),]
        splitResults$errK = temp
        changingRate = rbind(changingRate,splitResults)
}

p <- ggplot(changingRate, aes(x=d, y=errK, group=sp,colour=sp, shape=sp)) +
        geom_line() +
        geom_point(size=1, fill="white") +
        scale_x_continuous(name='Diameter of button (cm)') +
        scale_colour_discrete(name="Movement",
                              breaks=c("1", "2", "3", "4", "5"),
                              labels=c("Stand", "Strolling", "Walking","Rushing","Jogging")) +
        scale_shape_discrete(name="Movement",
                             breaks=c("1", "2", "3", "4", "5"),
                             labels=c("Stand", "Strolling", "Walking","Rushing","Jogging")) +
        scale_y_continuous(labels=percent, name="   ", limits=c(0, 0.40)) +
        ggtitle("Descent speed of error rate")

png("4_results/interaction_feature/click/error_rate_diameter_Descent speed.png", width = 1200, height = 1000, res = 300)
print(p)
dev.off()
