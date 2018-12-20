cal_error_rate <- function(NAME_FILE_SCREEN, threshold){
        # load the file 'interaction with screen'
        NAME_FILE_SCREEN <- NAME_FILE_SCREEN
        #NAME_FILE_SCREEN <- 'No000_Sp0_click.txt'
        FILE_DICT_SCREEN <- paste0(WORK_DICTIONARY, sep='/',paste0("4_data/aaa_data_324/click/",NAME_FILE_SCREEN))
        dat_intac <- read.csv(FILE_DICT_SCREEN,header = FALSE)[-1,]
        names(dat_intac) <- c('event','stdx','stdy','prex','prey','pret','lefx','lefy','left','watcht','phonet')
        dat_intac$event <- as.character(dat_intac$event)
        indx <- sapply(dat_intac,is.factor)
        dat_intac[indx] <- lapply(dat_intac[indx], function(x) as.numeric(as.character(x)))
        
        #############################################
        # delete error touch
        location_error <- c()
        for(i in 1:nrow(dat_intac)){
                if((dat_intac$stdx[i]-dat_intac$lefx[i])^2 + (dat_intac$stdy[i]-dat_intac$lefy[i])^2 > threshold){
                        location_error <- c(location_error,i)
                }
        }
        error_rate = length(location_error)/nrow(dat_intac)
        return(error_rate)
}