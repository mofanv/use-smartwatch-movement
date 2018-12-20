tense_data_more <- function(tenseDATA){
        dat <- tenseDATA
        disX = 45
        disY = 26
        pointx <- c(45,90,135,180,225,270,315) + disX/2
        pointy <- c(25.5,51.5,77.5,103.5,129.5,155.5,181.5,207.5,233.5,259.5,285.5, 311.5) +disY/2

        dataALL <- data.frame()
        
        for(i in 1:length(pointx)){
                for(j in 1:length(pointy)){
                        dataALL = rbind(dataALL,c(pointx[i],pointy[j]))
                }
        }
        names(dataALL) <- c('x','y')
        
        ########################
        # delete outside point
        indexBOO <- logical(length = nrow(dataALL))
        for(i in 1:nrow(dataALL)){
                #i=29
                x = dataALL$x[i]
                y = dataALL$y[i]
                boo1 = x >= 45
                boo2 = x <= 315
                a=c(45,103.5); b=c(180,25); k = (a[2]-b[2])/(a[1]-b[1]); t = a[2]-k*a[1]
                boo3 = (k*x + t - y) <= 0
                a=c(45,259.5); b=c(180,337.5); k = (a[2]-b[2])/(a[1]-b[1]); t = a[2]-k*a[1]
                boo4 = (k*x + t - y) >= 0
                a=c(180,337.5); b=c(315,259.5); k = (a[2]-b[2])/(a[1]-b[1]); t = a[2]-k*a[1]
                boo5 = (k*x + t - y) >= 0
                a=c(315,103.5); b=c(180,25); k = (a[2]-b[2])/(a[1]-b[1]); t = a[2]-k*a[1]
                boo6 = (k*x + t - y) <= 0
                indexBOO[i] = boo1 & boo2 & boo3 & boo4 & boo5 & boo6
        }
        #filter. give data to original point
        dataF <- dataALL[indexBOO,]
        dataF$mean_wind <- 0
        dataF$wind_dir <- 0
        for(i in 1:nrow(dataF)){
                indexCOM = which((dat$Lon == dataF$x[i]) & (dat$Lat == dataF$y[i]))
                if(length(indexCOM) > 0){
                        dataF[i,] = dat[indexCOM,]
                }else{
                        # calculate value of new point
                        xUP = dataF$x[i] + disX/2
                        xDOWN = dataF$x[i] - disX/2
                        yUP = dataF$y[i] + disY/2
                        yDOWN = dataF$y[i] - disY/2
                        
                        indexOLD = 0
                        indexL = which((dat$Lon == xDOWN) & (dat$Lat == yDOWN)) # find left point
                        indexR = which((dat$Lon == xUP) & (dat$Lat == yDOWN)) # find right point
                        indexU = which((dat$Lon == xDOWN) & (dat$Lat == yUP)) # find up point
                        indexD = which((dat$Lon == xUP) & (dat$Lat == yUP)) # find down point
                        if(length(indexL)>0){indexOLD = c(indexOLD, indexL)}
                        if(length(indexR)>0){indexOLD = c(indexOLD, indexR)}
                        if(length(indexU)>0){indexOLD = c(indexOLD, indexU)}
                        if(length(indexD)>0){indexOLD = c(indexOLD, indexD)}
                        
                        
                        dataF$mean_wind[i] = mean(dat$mean_wind[indexOLD])
                        dataF$wind_dir[i] = mean(dat$wind_dir[indexOLD])
                }
        }
        
        dataF <- dataF[!is.nan(dataF$mean_wind),]
        names(dataF) <- c('Lon','Lat','mean_wind','wind_dir')
        dataF <- rbind(tenseDATA, dataF)
        
        
        return(dataF)
}
