intac_feature_function <- function(dat_intac,NAME_FILE_SCREEN){
        # load the file 'interaction with screen'
        dat <- dat_intac
        
        # press t
        press_t_avg <- sum(dat$left-dat$pret)/nrow(dat)
        press_t_sd <- sd(dat$left-dat$pret)
        
        # offset distance
        off_dist_x <- dat$stdx-dat$prex
        off_dist_x_avg <- sum(off_dist_x)/nrow(dat)
        off_dist_x_sd <- sd(off_dist_x)
        
        off_dist_y <- dat$stdy-dat$prey
        off_dist_y_avg <- sum(off_dist_y)/nrow(dat)
        off_dist_y_sd <- sd(off_dist_y)
        
        off_dist <- apply(data.frame(off_dist_x^2+off_dist_y^2), 1, FUN=sqrt)
        off_dist_avg <- sum(off_dist)/nrow(dat)
        off_dist_sd <- sd(off_dist)
        
        #slide distance
        slid_dist_x <- dat$prex-dat$lefx
        slid_dist_x_avg <- sum(slid_dist_x)/nrow(dat)
        slid_dist_x_sd <- sd(slid_dist_x)
        
        slid_dist_y <- dat$prey-dat$lefy
        slid_dist_y_avg <- sum(slid_dist_y)/nrow(dat)
        slid_dist_y_sd <- sd(slid_dist_y)
        
        slid_dist <- apply(data.frame(slid_dist_x^2+slid_dist_y^2), 1, FUN=sqrt)
        slid_dist_avg <- sum(slid_dist)/nrow(dat)
        slid_dist_sd <- sd(slid_dist)
        
        #slide+off distance
        slid_off_dist_x <- dat$stdx-dat$lefx
        slid_off_dist_x_avg <- sum(slid_off_dist_x)/nrow(dat)
        slid_off_dist_x_sd <- sd(slid_off_dist_x)
        
        slid_off_dist_y <- dat$stdy-dat$lefy
        slid_off_dist_y_avg <- sum(slid_off_dist_y)/nrow(dat)
        slid_off_dist_y_sd <- sd(slid_off_dist_y)
        
        slid_off_dist <- apply(data.frame(slid_off_dist_x^2+slid_off_dist_y^2), 1, FUN=sqrt)
        slid_off_dist_avg <- sum(slid_off_dist)/nrow(dat)
        slid_off_dist_sd <- sd(slid_off_dist)
        
        dat_feature <- data.frame(NAME_FILE_SCREEN=NAME_FILE_SCREEN,
                                  press_t_avg = press_t_avg, press_t_sd=press_t_sd,
                                  off_dist_x_avg = off_dist_x_avg, off_dist_x_sd = off_dist_x_sd,
                                  off_dist_y_avg = off_dist_y_avg, off_dist_y_sd = off_dist_y_sd,
                                  off_dist_avg = off_dist_avg, off_dist_sd = off_dist_sd,
                                  slid_dist_x_avg = slid_dist_x_avg, slid_dist_x_sd = slid_dist_x_sd,
                                  slid_dist_y_avg = slid_dist_y_avg, slid_dist_y_sd = slid_dist_y_sd,
                                  slid_dist_avg = slid_dist_avg, slid_dist_sd = slid_dist_sd,
                                  slid_off_dist_x_avg = slid_off_dist_x_avg, slid_off_dist_x_sd = slid_off_dist_x_sd,
                                  slid_off_dist_y_avg = slid_off_dist_y_avg, slid_off_dist_y_sd = slid_off_dist_y_sd,
                                  slid_off_dist_avg = slid_off_dist_avg, slid_off_dist_sd = slid_off_dist_sd
        )
        return(dat_feature)
        
}