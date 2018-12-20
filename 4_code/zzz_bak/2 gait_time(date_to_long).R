"leftArm"
"B0B448BAEC7E"
"rightArm"
"B0B448B7C6D1"
"leftLeg"
"B0B4486E4145"
"rightLeg"
"B0B4486F003D"

options(digits.secs=3, digits=13)
library(data.table)
library(ggplot2)
WORK_DICTIONARY <- "/Users/mofan/Documents/master_thesis"
setwd(WORK_DICTIONARY)

files <- list.files(path = "4_data/CSV_FILE previous", pattern = ".csv", full.names = T)

for(i in 1:length(files)){
        DIR_NAME <- files[i]
        NAME_FILE_SENSOR <- substr(DIR_NAME,nchar(DIR_NAME)-35,nchar(DIR_NAME))
        
        # load the file, and extract date and change it to numeric
        FILE_DICT_SENSOR <- DIR_NAME
        dat_sensor <- read.csv(FILE_DICT_SENSOR)
        dat_sensor$Time <- as.character(dat_sensor$Time)
        ID_SENSOR <- substr(NAME_FILE_SENSOR,1,12)
        DATE <- gsub("_","-",substr(NAME_FILE_SENSOR,16,23))
        
        transfer_time <- function(x){
                x <- paste0(substr(x,1,8),'.',substr(x,10,12)) # ":" to "."
                date_time <- paste(DATE,sep=" ",x)
                x <- as.numeric(strptime(date_time, "%y-%m-%d %H:%M:%OS"))
        }
        dat_sensor$Time <- apply(as.data.frame(dat_sensor$Time),1,FUN=transfer_time)
        
        names(dat_sensor) <- c("time","inters","accx","accy","accz","angx","angy","angz")
        
        source('4_code/ang_pick_function.R')
        dat_sensor$angx <- ang_pick(dat_sensor$angx)
        dat_sensor$angy <- ang_pick(dat_sensor$angy)
        dat_sensor$angz <- ang_pick(dat_sensor$angz)
        
        NEW_DIR <- paste0("/Users/mofan/Documents/master_thesis/4_data/CSV_FILE previous/processed/",NAME_FILE_SENSOR)
        write.csv(dat_sensor, NEW_DIR)
        print(paste0(i,"/",length(files)))
}

dat_left <- read.csv("/Users/mofan/Documents/master_thesis/4_data/CSV_FILE/processed/B0B4486E4145_2017-11-19_13-08-04.csv")
dat_right <- read.csv("/Users/mofan/Documents/master_thesis/4_data/CSV_FILE/processed/B0B4486F003D_2017-11-19_13-08-04.csv")

library(ggplot2)
temp1 <- dat_left[0:300,]
temp2 <- dat_right[0:300,]
p1 <- ggplot(data=temp1, aes(x=inters,y=angz)) +
        geom_line()
p2 <- ggplot(data=temp2, aes(x=inters,y=-angz)) +
        geom_line()

source("/Users/mofan/Documents/master_thesis/4_code/multiplot_function.R")
multiplot(p1, p2, col=1)