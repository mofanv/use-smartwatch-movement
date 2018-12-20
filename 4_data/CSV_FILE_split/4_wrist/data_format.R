DIR1 = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/4_wrist/0wrist_range.csv'
dat = read.csv(DIR1, header = FALSE)

dat[1,1] = 0
dat$V1 <- as.numeric(as.character(dat$V1))
dat$V3 <- as.character(dat$V3)
dat$V4 <- as.character(dat$V4)

### start
minutes = as.numeric(substr(dat$V3,1,2))
seconds = as.numeric(substr(dat$V3,4,5))
mseconds = as.numeric(substr(dat$V3,7,7))

all = minutes*60*1000 + seconds*1000 + mseconds
dat$V3 = all

### end
dat$V4 <- as.character(dat$V4)
minutes = as.numeric(substr(dat$V4,1,2))
seconds = as.numeric(substr(dat$V4,4,5))
mseconds = as.numeric(substr(dat$V4,7,7))

all = minutes*60*1000 + seconds*1000 + mseconds
dat$V4 = all

names(dat) = NA

DIR2 = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/4_wrist/0wrist_range_done.csv'
write.csv(dat, DIR2)
