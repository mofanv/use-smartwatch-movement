visualization <- function(dat_intac, Sp, direction){
        library(ggplot2)
        library(tidyr)
        dat_intac = dat_intac
        files_index <- grep(direction, dat_intac$mark)
        dat_intac = dat_intac[files_index,]
        dat_intac$kind <- "slide"
        
        circleFun <- function(center = c(180,180),diameter = 320, npoints = 100){
                r = diameter / 2
                tt <- seq(0,2*pi,length.out = npoints)
                xx <- center[1] + r * cos(tt)
                yy <- center[2] + r * sin(tt)
                return(data.frame(x = xx, y = yy))
        }
        dat_cycle <- circleFun()
        dat_cycle_0 <- dat_cycle
        dat_cycle$no <- 1:100
        dat_cycle_0$no <- c(100,1:99)
        dat_cycle <- rbind(dat_cycle,dat_cycle_0)
        dat_cycle$mark <- "0"
        dat_cycle$kind <- "edge"
        dat_intac <- rbind(dat_cycle,dat_intac)
        dat_intac$y <- -dat_intac$y
        
        title = paste0("slide_Sp", Sp, " ", direction, " slide")
        
        p <- ggplot(dat_intac,aes(x=x,y=y,group=no)) +
                geom_line(size = 0.2) +
                theme(panel.grid.minor.x=element_blank(),
                      panel.grid.major.x=element_blank(),
                      panel.grid.minor.y=element_blank(),
                      panel.grid.major.y=element_blank()) +
                ggtitle(paste0(title))
        return(p)
}
