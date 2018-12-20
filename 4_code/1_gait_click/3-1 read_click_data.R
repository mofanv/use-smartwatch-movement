read_click_data <- function(Sp, threshold){
        
        options(digits.secs=3, digits=13)
        library(data.table)
        library(plotrix)
        source("4_code/interaction_feature/1-1 read_click_data.R")
        source("4_code/interaction_feature/1-2 clean_click_data.R")
        
        k=1
        
        TXT_FILE_NAME <- read_intac(Sp)
        dat_intac_min <- vector("list", 3)
        location_error <- c()
        intec_feature <- c()
        
        length(TXT_FILE_NAME)
        for(i in 1:length(TXT_FILE_NAME)){
                dat_intac_min[[i]] <- data_interaction_function(TXT_FILE_NAME[i], threshold)[[1]]
                location_error <- c(location_error,data_interaction_function(TXT_FILE_NAME[i], threshold)[[2]])
                intec_feature <- rbind(intec_feature,data_interaction_function(TXT_FILE_NAME[i], threshold)[[3]])
        }
        
        dat_intac <- data.frame()
        for(i in 1:length(TXT_FILE_NAME)){
                dat_intac_min[[i]]$no = 10000*i + dat_intac_min[[i]]$no
                dat_intac <- rbind(dat_intac, dat_intac_min[[i]])
        }
        
        return(dat_intac)
}
