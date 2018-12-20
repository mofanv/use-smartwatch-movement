clean_click_data <- function(dat_intac, threshold){
        names(dat_intac) <- c('stdx','stdy','prex','prey','pret','lefx','lefy','left',
                              'watcht','phonet','t','phase','noperson','sp')
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
        dat_intac$error_mark = 0
        if(length(location_error)>0){dat_intac$error_mark[location_error] = 1}
        return(dat_intac)
}
