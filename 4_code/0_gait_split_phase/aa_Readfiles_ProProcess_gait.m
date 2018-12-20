function [readable_gait] = aa_Readfiles_ProProcess_gait()
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%
    % read gait data
  
    DIR_gait = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/';
    fileFolder_gait =fullfile(DIR_gait);%path
    dirOutput_gait = dir(fullfile(fileFolder_gait,'*')); %all the files
    fileNames_gait = {dirOutput_gait.name}';
    
    readable_gait = cell((length(fileNames_gait)-3), 1);

    % every person
    for i= 4:length(fileNames_gait) %exclude first 3
        fileFolder_inner = fullfile(strcat(DIR_gait,fileNames_gait{i})); %open each participant's file
        dirOutput_inner = dir([fileFolder_inner,filesep,'*.','csv']); 
        datafiles = {dirOutput_inner.name}';

        filesName_split = regexp(datafiles, '_', 'split');

        % every speed
        readable_names_per = cell(length(filesName_split), 1);
        for j = 1:length(filesName_split)
            sp = char(filesName_split{j}(1));
            sensorID = char(filesName_split{j}(2));

            if(strcmp(sensorID,'B0B448BAEC7E')) limb = 'left_arm';
            end
            if(strcmp(sensorID,'B0B448B7C6D1')) limb = 'right_arm';
            end
            if(strcmp(sensorID,'B0B4486E4145')) limb = 'left_leg';
            end
            if(strcmp(sensorID,'B0B4486F003D')) limb = 'right_leg';
            end
            
            readable_names_per{j} = {num2str(i-4), sp, limb, strcat(fileFolder_inner,'/',datafiles{j})};
            %data{j} = csvread(strcat(fileFolder_inner,'/',datafiles{j}),1,1);
        end
        readable_gait{i-3} = readable_names_per;
    end
end
    
    