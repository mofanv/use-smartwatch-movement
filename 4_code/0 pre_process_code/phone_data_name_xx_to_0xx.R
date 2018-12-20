path <- "/Users/mofan/Documents/master_thesis/4_data/aaa_data_324/click"
setwd(path)
old.file.names <- dir()

## new rule of files names
new.file.names <- sapply(old.file.names,function(file){
        
        fileSplit = strsplit(file, '_')[[1]]
        noNum = sub('No','',fileSplit[1])
        noStr = paste0('No0', as.character(as.numeric(noNum) + 22))
        file = paste0(noStr, '_', fileSplit[2], '_', fileSplit[3])
        return (file)
})

file.rename(old.file.names,new.file.names)
