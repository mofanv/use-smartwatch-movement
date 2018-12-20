function [readable_intac] = bb_Readfiles_Click()
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    % read intaction data
 
    DIR_intac = '/Users/mofan/Documents/master_thesis/4_data/aaa_data_324/click_pure/';
    fileFolder_intac =fullfile(DIR_intac);%path
    dirOutput_intac = dir(fullfile(fileFolder_intac,'*')); %all the files
    fileNames_intac = {dirOutput_intac.name}';
    
    filesName_split = regexp(fileNames_intac, '_', 'split');
    
    readable_names_per = cell((length(fileNames_intac)-3), 1);
    
    for(i = 4:length(filesName_split))
        np = filesName_split{i}(1);
        sp = filesName_split{i}(2);
        DIR_inner = strcat(DIR_intac,fileNames_intac{i});
        readable_names_per{i-3} = {np, sp, DIR_inner};
    end
    readable_intac = readable_names_per;
end