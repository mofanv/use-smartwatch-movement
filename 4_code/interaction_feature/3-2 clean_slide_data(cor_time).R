clean_data_function <- function(NAME_FILE_SCREEN, threshold){
        #NAME_FILE_SCREEN <- "No021_Sp2_slip.txt"
        #threshold = c(100,60)
        #i=1
        
        NAME_FILE_SCREEN <- NAME_FILE_SCREEN
        
        WORK_DICTIONARY <- "/Users/fanvincentmo/Documents/master_thesis"
        setwd(WORK_DICTIONARY)
        FILE_DICT_SCREEN <- paste0(WORK_DICTIONARY,sep='/',paste0("4_data/aaa_data_324/slip/",NAME_FILE_SCREEN))
        source("4_code/interaction_feature/3-2-1 mark_slide(left_right).R")
        source("4_code/interaction_feature/3-2-2 calculate_slide_feature.R")
        
        dat_intac <- read.table(FILE_DICT_SCREEN,header = FALSE)
        dat_intac <- apply(dat_intac, 2, as.character)
        
        varX <- vector(mode="numeric",length=0)
        varY <- vector(mode="numeric",length=0)
        
        data_intac_per <- data.frame()
        timeDownUp <- c()
        intac_feature <- data.frame()
        
        for(i in 1:length(dat_intac)){
                # add comma to split Y and timeUP
                dat_intac_Split <- strsplit(dat_intac[i], ",")[[1]]
                numData <- length(dat_intac_Split)
                
                timeDOWN <- dat_intac_Split[4]
                numTime <- nchar(timeDOWN)
                
                timeUP_Y <- dat_intac_Split[length(dat_intac_Split)-2]
                timeUP <- substr(timeUP_Y, nchar(timeUP_Y)+1-numTime, nchar(timeUP_Y))
                Y <- substr(timeUP_Y, 1, nchar(timeUP_Y)-numTime)
                
                #rebuild slide data
                dat_intac_Split = dat_intac_Split[-c(numData-2, numData-1, numData)]
                dat_intac_Split = c(dat_intac_Split,Y,timeUP)
                numData <- length(dat_intac_Split)
                
                varX <- c()
                varY <- c()
                varX[1] = dat_intac_Split[2]
                varY[1] = dat_intac_Split[3]
                k=2
                
                for(j in 1:((numData-5)/2)){
                        varX[k] = dat_intac_Split[3+2*j]
                        varY[k] = dat_intac_Split[4+2*j]
                        k = k+1
                }
                
                data_intac_per_slide <- data.frame(varX=varX, varY=varY, no=i)
                #mark the slide (left, right, or error)
                mark <- mark_slide(data_intac_per_slide,threshold)
                data_intac_per_slide$mark = mark
                data_intac_per <- rbind(data_intac_per, data_intac_per_slide)
                
                #calculate the feature
                intac_feature_per <- slide_feature(data_intac_per_slide, timeDOWN, timeUP)
                if(mark == "left") {mark_num = 1}
                else if(mark == "right") {mark_num = 2}
                else if(mark == "error") {mark_num = 0}
                intac_feature <- rbind(intac_feature, c(intac_feature_per, mark_num))
                
                #record the time
                timeDownUp <- rbind(timeDownUp, c(timeDOWN, timeUP, i))
        }
        
        names(intac_feature) <- c('stX', 'stY', 'angle', 'disALL', 'travelDIS', 'travelANG', 'Dur', 'meanCur', 'meanCur2', 'sdCur', 'sdCur2', 'S' , 'endX','endY', 'mark')
        results <- list(data_intac_per, timeDownUp, intac_feature)
        return(results)
}