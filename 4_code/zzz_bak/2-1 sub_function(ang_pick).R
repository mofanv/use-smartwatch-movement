ang_pick <- function(dat){
        AVG <- mean(dat[1:5])
        pick_big_positive_90 <- function(x){
                if(x < -(180-AVG-15)){x = 360 + x}else{x = x}
        }
        pick_small_negative_90 <- function(x){
                if(x > 180+AVG-15){x = x - 360}else{x = x}
        }
        
        if(AVG>=0){
                dat <- apply(as.data.frame(dat),1,FUN=pick_big_positive_90)
        }
        if(AVG<0){
                dat <- apply(as.data.frame(dat),1,FUN=pick_small_negative_90)
        }
        return(dat)
}