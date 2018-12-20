mark_slide <- function(data_intac_per_slide,threshold){
        
        dat_temp <- data_intac_per_slide
        threshold_X1 = threshold[1]
        threshold_X2 = threshold[2]
        
        dat_temp$varX <- as.numeric(as.character(dat_temp$varX))
        dat_temp$varY <- as.numeric(as.character(dat_temp$varY))
        
        nr = nrow(dat_temp)
        disX = dat_temp$varX[nr] - dat_temp$varX[1]
        disY = dat_temp$varY[nr] - dat_temp$varY[1]
        
        
        if(abs(disY) > abs(disX)){
                if( abs(disX) < threshold_X1){
                        mark = "error"  
                }else{
                        if(disX < 0){
                                mark = "left"
                        }else{
                                mark = "right"
                        }
                }
        }else{
                if( abs(disX) < threshold_X2){
                        mark = "error"  
                }else{
                        if(disX < 0){
                                mark = "left"
                        }else{
                                mark = "right"
                        }
                }
        }
        
        return(mark)
}
