options(digits.secs=3, digits=13)
library(data.table)
library(plotrix)
library(ggplot2)

WORK_DICTIONARY <- "/Users/mofan/Documents/master_thesis"
setwd(WORK_DICTIONARY)

intac_feature_Sp0 <- read.csv("4_data/intecaction_feature/intecaction_feature_Sp0.csv")
intac_feature_Sp2 <- read.csv("4_data/intecaction_feature/intecaction_feature_Sp2.csv")
intac_feature_Sp3 <- read.csv("4_data/intecaction_feature/intecaction_feature_Sp3.csv")
intac_feature_Sp4 <- read.csv("4_data/intecaction_feature/intecaction_feature_Sp4.csv")
intac_feature_Sp5 <- read.csv("4_data/intecaction_feature/intecaction_feature_Sp5.csv")
intac_feature_Sp0$sp = 1; intac_feature_Sp2$sp = 2; intac_feature_Sp3$sp = 3; 
intac_feature_Sp4$sp = 4; intac_feature_Sp5$sp = 5

intac_feature_Sp0 <- apply(intac_feature_Sp0[,-c(1,2)],2,FUN=mean)
intac_feature_Sp2 <- apply(intac_feature_Sp2[,-c(1,2)],2,FUN=mean)
intac_feature_Sp3 <- apply(intac_feature_Sp3[,-c(1,2)],2,FUN=mean)
intac_feature_Sp4 <- apply(intac_feature_Sp4[,-c(1,2)],2,FUN=mean)
intac_feature_Sp5 <- apply(intac_feature_Sp5[,-c(1,2)],2,FUN=mean)


intac_feature <- rbind(rbind(rbind(rbind(intac_feature_Sp0,intac_feature_Sp2),intac_feature_Sp3),intac_feature_Sp4),intac_feature_Sp5)
intac_feature <- as.data.frame(intac_feature)

ggplot(intac_feature,aes(x=sp,y=press_t_avg)) +
        geom_point() +
        geom_line()

p1<- ggplot(intac_feature,aes(x=sp,y=off_dist_x_avg)) +
        geom_point() +
        geom_line()

p2<- ggplot(intac_feature,aes(x=sp,y=off_dist_y_avg)) +
        geom_point() +
        geom_line()

p3<- ggplot(intac_feature,aes(x=sp,y=off_dist_avg)) +
        geom_point() +
        geom_line()

p4<- ggplot(intac_feature,aes(x=sp,y=slid_dist_x_avg)) +
        geom_point() +
        geom_line()

p5<- ggplot(intac_feature,aes(x=sp,y=slid_dist_y_avg)) +
        geom_point() +
        geom_line()

p6<- ggplot(intac_feature,aes(x=sp,y=slid_dist_avg)) +
        geom_point() +
        geom_line()

p7<- ggplot(intac_feature,aes(x=sp,y=slid_off_dist_x_avg)) +
        geom_point() +
        geom_line()

p8<- ggplot(intac_feature,aes(x=sp,y=slid_off_dist_y_avg)) +
        geom_point() +
        geom_line()

p9<- ggplot(intac_feature,aes(x=sp,y=slid_off_dist_avg)) +
        geom_point() +
        geom_line()

source("4_code/multiplot_function.R")
multiplot(p1, p2, p3, p4, p5, p6, p7, p8, p9, cols=3)
