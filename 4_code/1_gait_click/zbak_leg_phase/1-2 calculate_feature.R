calculate_feature <- function(dat_intac){
        # load the file 'interaction with screen'
        dat <- dat_intac
        dataFea <- data.frame(phase=dat$phase, noperson=dat$noperson, sp=dat$sp, error_mark=dat$error_mark)
        # press t
        dataFea$press_t_avg <- dat$left - dat$pret
        # offset distance
        dataFea$off_dist_x <- dat$stdx - dat$prex
        dataFea$off_dist_y <- dat$stdy - dat$prey
        dataFea$off_dist <- sqrt(dataFea$off_dist_x^2 + dataFea$off_dist_y^2)
        #slide distance
        dataFea$slid_dist_x <- dat$prex - dat$lefx
        dataFea$slid_dist_y <- dat$prey - dat$lefy
        dataFea$slid_dist <- sqrt(dataFea$slid_dist_x^2 + dataFea$slid_dist_y^2)
        #slide+off distance
        dataFea$slid_off_dist_x <- dat$stdx - dat$lefx
        dataFea$slid_off_dist_y <- dat$stdy - dat$lefy
        dataFea$slid_off_dist <- sqrt(dataFea$slid_off_dist_x^2 + dataFea$slid_off_dist_y^2)
        
        dataFea$phase <- as.factor(dataFea$phase)
        dataFea$sp <- as.factor(dataFea$sp)
        
        return(dataFea)
}