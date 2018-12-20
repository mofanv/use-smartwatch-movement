DIR1 = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/p21/sp3_B0B4486E4145_2018-03-24_14-55-05.csv'
left = read.csv(DIR1)

sec = c(left$Second, left$Second, left$Second)
acc = c(left$AccelerationX, left$AccelerationY, left$AccelerationZ)
ang = c(left$EulerAnglesX, left$EulerAnglesY, left$EulerAnglesZ)
mark = c(rep('x', time=nrow(left)),rep('y', time=nrow(left)),rep('z', time=nrow(left)))
dat = data.frame(time=sec, acc=acc, ang=ang, mark=mark)

library(ggplot2)
ggplot(dat, aes(x=sec, y=acc,group=mark, color=mark)) +
        geom_line() +
        xlim(11.75,13)

library(ggplot2)
ggplot(dat, aes(x=sec, y=ang,group=mark, color=mark)) +
        geom_line() +
        xlim(11.75,13)
