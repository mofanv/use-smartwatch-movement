slide_feature <- function(data_intac_per_slide, timeDOWN, timeUP){
        
        Pslide <- data_intac_per_slide
        Pslide$varX = as.numeric(as.character(Pslide$varX))
        Pslide$varY = as.numeric(as.character(Pslide$varY))
        nr = nrow(Pslide)
        
        # Startpoint X
        stX = Pslide$varX[1]
        
        # Startpoint Y
        stY = Pslide$varY[1]
        
        # slide angle
        disX = Pslide$varX[nr] - Pslide$varX[1]
        disY = Pslide$varY[nr] - Pslide$varY[1]
        angle = atan(disY/abs(disX)) * (180/pi)
        
        # Displacement ALL
        disALL = sqrt(disX^2 + disY^2)
        
        # Traveled distance
        # Angle of movement
        # Curvature
        tempDIS = c(); tempANG = c(); tempCur = c(); tempCur2 = c()
        for(i in 2:nr){
                disXi = Pslide$varX[i] - Pslide$varX[i-1]
                disYi = Pslide$varY[i] - Pslide$varY[i-1]
                
                tempDIS_ = sqrt(disXi^2 + disYi^2)
                tempANG_ = atan(disYi/abs(disXi)) * (180/pi)
                tempCur_ = tempANG_/tempDIS_
                tempCur2_ = tempCur_/tempDIS_
                
                tempDIS = c(tempDIS, tempDIS_)
                tempANG = c(tempANG, tempANG_)
                tempCur = c(tempCur, tempCur_)
                tempCur2 = c(tempCur2, tempCur2_)
        }
        
        travelDIS = sum(tempDIS)
        travelANG = sum(tempANG)
        meanCur = mean(tempCur)
        meanCur2 = mean(tempCur2)
        sdCur = sd(tempCur)
        sdCur2 = sd(tempCur2)
        if(length(tempCur)==1){sdCur = 0}
        if(length(tempCur2)==1){sdCur2 = 0}
        
        # Duration of movement
        Dur = as.numeric(timeUP) - as.numeric(timeDOWN)
        
        # Straightness (S)
        S = disALL/travelDIS
        
        # Endpoint X
        endX = Pslide$varX[nr]
        
        # Endpoint Y
        endY = Pslide$varY[nr]
        
        vec = c(stX, stY, angle, disALL, travelDIS, travelANG, Dur, meanCur, meanCur2, sdCur, sdCur2, S, endX, endY)
        return(vec)
}

