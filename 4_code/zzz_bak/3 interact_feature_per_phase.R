WORK_DICTIONARY <- "/Users/mofan/Documents/master_thesis/"
setwd(WORK_DICTIONARY)
dat <- read.csv("gait_analysis/4_data/processed_by_matlab/3_interact_feature_per_phase.csv")
names(dat) <- c('stdx','stdy','prex','prey','pret','lefx','lefy','left','watcht','phonet','computert','foot','phase')

dat$watcht <- dat$watcht/1000
dat$phonet <- dat$phonet/1000

#foot_phase category
index <- dat$foot==0 | dat$phase==0
dat <- dat[!index,]
dat$foot <- as.factor(dat$foot)
dat$phase <- as.factor(dat$phase)
levels(dat$foot) <- c("left","right")
levels(dat$phase) <- c("swing","loading")


dat$offx <- dat$stdx - dat$prex
dat$offy <- dat$stdy - dat$prey
dat$offdisp <- apply(data.frame(dat$offx^2+dat$offy^2), 1, FUN=sqrt)

dat$slidx <- dat$prex - dat$lefx
dat$slidy <- dat$prey - dat$lefy
dat$sliddisp <- apply(data.frame(dat$slidx^2+dat$slidy^2), 1, FUN=sqrt)

dat$off_slidx <- dat$stdx - dat$lefx
dat$off_slidy <- dat$stdy - dat$lefy
dat$off_sliddisp <- apply(data.frame(dat$off_slidx^2+dat$off_slidy^2), 1, FUN=sqrt)

source("4_code/function_summarySE.R")
library(ggplot2)
pd <- position_dodge(0.1)

sumresult <- summarySE(dat, measurevar = "offx", groupvars = c("foot","phase"))
p1 <- ggplot(sumresult, aes(x=foot,y=offx,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=offx-ci,ymax=offx+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("offset x")

sumresult <- summarySE(dat, measurevar = "offy", groupvars = c("foot","phase"))
p2 <- ggplot(sumresult, aes(x=foot,y=offy,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=offy-ci,ymax=offy+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("offset y")

sumresult <- summarySE(dat, measurevar = "offdisp", groupvars = c("foot","phase"))
p3 <- ggplot(sumresult, aes(x=foot,y=offdisp,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=offdisp-ci,ymax=offdisp+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("offset displacement")

sumresult <- summarySE(dat, measurevar = "slidx", groupvars = c("foot","phase"))
p4 <- ggplot(sumresult, aes(x=foot,y=slidx,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=slidx-ci,ymax=slidx+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("slide x")

sumresult <- summarySE(dat, measurevar = "slidy", groupvars = c("foot","phase"))
p5 <- ggplot(sumresult, aes(x=foot,y=slidy,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=slidy-ci,ymax=slidy+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("slide y")

sumresult <- summarySE(dat, measurevar = "sliddisp", groupvars = c("foot","phase"))
p6 <- ggplot(sumresult, aes(x=foot,y=sliddisp,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=sliddisp-ci,ymax=sliddisp+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("slide displacement")

sumresult <- summarySE(dat, measurevar = "off_slidx", groupvars = c("foot","phase"))
p7 <- ggplot(sumresult, aes(x=foot,y=off_slidx,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=off_slidx-ci,ymax=off_slidx+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("offset + slide x")

sumresult <- summarySE(dat, measurevar = "off_slidy", groupvars = c("foot","phase"))
p8 <- ggplot(sumresult, aes(x=foot,y=off_slidy,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=off_slidy-ci,ymax=off_slidy+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("offset + slide y")

sumresult <- summarySE(dat, measurevar = "off_sliddisp", groupvars = c("foot","phase"))
p9 <- ggplot(sumresult, aes(x=foot,y=off_sliddisp,colour=phase,group=phase)) +
        geom_errorbar(aes(ymin=off_sliddisp-ci,ymax=off_sliddisp+ci), width=0.1, position=pd) +
        geom_line(position=pd) + geom_point(position=pd) +
        ggtitle("offset + slide displacement")

source("4_code/multiplot_function.R")
#png("No1_Sp4.png",width = 2000,height = 1500,res = 200)
#multiplot(p1, p2, p3, p4, p5, p6, p7, p8, p9, cols=3)
png("No1_Sp3.png",width = 2000,height = 500,res = 200)
multiplot(p7, p8, p9, cols=3)
dev.off()

