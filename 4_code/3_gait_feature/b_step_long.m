clc
clear

key1 = '1_look'; key2 = '2_touch'; key3 = '4_wrist';
cycle_dis = 20;

for key_ = 1:3
    if key_ == 1        key = key1;
    elseif key_ == 2        key = key2;
    elseif key_ == 3        key = key3;
    end
    
feature_step = [];
feature_step12 = [];
    
%np = [0:7,9:11,13:16,20,21];
for i = [0:1,3:13,15:21,24,29,31:32,35:36,38:44]
    for j = 2:5
    %i = 10; j = 3;
    % feature of left leg
    DIR = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/',key,'/p',...
                num2str(i),'_sp',num2str(j),'_left_leg.csv');
    dat = dlmread(DIR);
    dat(:,1) = dat(:,1) - dat(1,1);
    [T1,dat_y1] = bb_step_long_dealing(dat);
    [start_time1, end_time1, distance1] = bc_feature_distance(T1, dat_y1, cycle_dis,i,j);
    [stepnum1, steplong1] = bd_feature_step_number(dat(:,1), dat(:,3), start_time1, end_time1, distance1);
    
    % feature of right leg
    DIR = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/',key,'/p',...
                num2str(i),'_sp',num2str(j),'_right_leg.csv');
    dat = dlmread(DIR);
    dat(:,1) = dat(:,1) - dat(1,1);
    [T2,dat_y2] = bb_step_long_dealing(dat);
    [start_time2, end_time2, distance2] = bc_feature_distance(T2, dat_y2, cycle_dis,i,j);
    [stepnum2, steplong2] = bd_feature_step_number(dat(:,1), dat(:,3), start_time2, end_time2, distance2);
    
    % together
    distance = (distance1 + distance2)/2;
    stepnum = (stepnum1 + stepnum2)/2;
    steplong = (steplong1 + steplong2)/2;
    
    i
    j
    feature_step_12 = [i, j, distance1, distance2, stepnum1, stepnum2, steplong1, steplong2];
    feature_step_ = [i, j, distance, stepnum, steplong];
    feature_step12 = [feature_step12; feature_step_12];
    feature_step = [feature_step; feature_step_];
    end
end

DIR = strcat('/Users/mofan/Documents/master_thesis/4_results/finial_gait_feature/step_feature_',key,'.csv');
dlmwrite(DIR,feature_step)

end