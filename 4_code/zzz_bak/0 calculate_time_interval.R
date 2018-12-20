dat = c('12:52:12:835',
        '12:52:13:622',
        '12:52:14:409',
        '12:52:15:060',
        '12:52:15:751',
        '12:52:16:480',
        '12:52:17:262',
        '12:52:17:974',
        '12:52:18:662')

DATE = "17-11-19"
for(i in 1:length(dat)){
        dat[i] <- paste0(substr(dat[i],1,8),'.',substr(dat[i],10,12)) # ":" to "."
        date_time <- paste(DATE,sep=" ",dat[i])
        dat[i] <- as.numeric(strptime(date_time, "%y-%m-%d %H:%M:%OS"))
}

dat <- as.numeric(dat)
dat_inter <- read.csv("/Users/mofan/Documents/master_thesis/4_data/aaa_data previous/No1_Sp0_click.txt")
names(dat_inter) <- c('event','stdx','stdy','prex','prey','pret','lefx','lefy','left','watcht','phonet')

dat_com <- data.frame(computer_t = dat,
                      watch_t = dat_inter$watcht[1:9] * 1/1000,
                      phone_t = dat_inter$phonet[1:9] * 1/1000
                      )

dat_com$t1 <- (dat_com$computer_t - dat_com$watch_t)
dat_com$t2 <- (dat_com$computer_t - dat_com$phone_t)
mean(dat_com$t1)
sd(dat_com$t1)
mean(dat_com$t2)
sd(dat_com$t2)



################
dat = c('15:04:59:216',
        '15:05:29:691',
        '15:06:19:484')

DATE = "18-03-21"
for(i in 1:length(dat)){
        dat[i] <- paste0(substr(dat[i],1,8),'.',substr(dat[i],10,12)) # ":" to "."
        date_time <- paste(DATE,sep=" ",dat[i])
        dat[i] <- as.numeric(strptime(date_time, "%y-%m-%d %H:%M:%OS"))
}
dat