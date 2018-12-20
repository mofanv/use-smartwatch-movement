WD = '/Users/fanvincentmo/Documents/master_thesis'
setwd(WD)
perinfo <- read.csv('4_data/paper_data_324/personal_information.csv')
perinfo_prior <- read.csv('4_data/paper_data_324/personal_information_prior.csv')
perinfo = rbind(perinfo,perinfo_prior)

# gender
summary(perinfo$gender)

# age
mean(perinfo$age)
sd(perinfo$age)

# height
mean(perinfo$height[perinfo$gender=='m'])
sd(perinfo$height[perinfo$gender=='m'])
mean(perinfo$height[perinfo$gender=='f'])
sd(perinfo$height[perinfo$gender=='f'])

# weight
mean(perinfo$weight[perinfo$gender=='m'])
sd(perinfo$weight[perinfo$gender=='m'])
mean(perinfo$weight[perinfo$gender=='f'])
sd(perinfo$weight[perinfo$gender=='f'])

# walk time and distance
summary(as.factor(perinfo$walktime))/47
summary(as.factor(perinfo$walkdistance))/47

# run time and distance
summary(as.factor(perinfo$runtime))/47
summary(as.factor(perinfo$rundistance))/47

# smart phone
mean(perinfo$phonetime)
sd(perinfo$phonetime)
summary(as.factor(perinfo$phonefrequency))/47

# smart band
summary(as.factor(perinfo$bandboo))
perinfo$bandyearbefore[perinfo$bandyearbefore!=0] # number
mean(perinfo$bandyearbefore[perinfo$bandyearbefore!=0])
perinfo$bandyearnow[perinfo$bandyearnow!=0]  # number
mean(perinfo$bandyearnow[perinfo$bandyearnow!=0])

# normal watch
summary(as.factor(perinfo$watchboo))
perinfo$watchyearbefore[perinfo$watchyearbefore!=0] # number
mean(perinfo$watchyearbefore[perinfo$watchyearbefore!=0])
sd(perinfo$watchyearbefore[perinfo$watchyearbefore!=0])
perinfo$watchyearnow[perinfo$watchyearnow!=0]  # number
mean(perinfo$watchyearnow[perinfo$watchyearnow!=0])

# smart watch
perinfo$smartwatchboo
perinfo$smartwatchtime
perinfo$smartwatchyear

# wrist
summary(as.factor(perinfo$wristletboo))
perinfo$wristletyearbefore[perinfo$wristletyearbefore!=0] # number
mean(perinfo$wristletyearbefore[perinfo$wristletyearbefore!=0])
perinfo$wristletyearnow[perinfo$wristletyearnow!=0]  # number
mean(perinfo$wristletyearnow[perinfo$wristletyearnow!=0])

