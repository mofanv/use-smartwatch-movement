read_intac <- function(Sp){
        i=Sp
        options(digits.secs=3, digits=13)
        library(data.table)
        
        files <- list.files(path = "4_data/aaa_data_324/slip", pattern = ".txt", full.names = T)
        files <- sub("4_data/aaa_data_324/slip/","",files)
        
        index <- c(0,2,3,4,5)
        Sp_index <- paste0("Sp", as.character(index[i]))
        
        files_index <- grep(Sp_index,files)
        files_Sp <- files[files_index]
        
        return(files_Sp)
}