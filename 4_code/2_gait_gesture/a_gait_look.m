clc
clear

cycle_time = dlmread('/Users/mofan/Documents/master_thesis/4_results/gait/phase_time(ALL).csv');
feature_look = [];

%np = [0:1,3:13,15:21,23:25,28:29,31:33,35:36,38:44];
for i = [0:1,3:13,15:21,23:25,29,31:32,35:36,38:44]
    for j = 1:5
%i = 7; j = 3;
        DIR = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/1_look/p',...
                num2str(i),'_sp',num2str(j),'_left_arm.csv');
        dat = dlmread(DIR);
        data.data = dat;
        [data_Resample, data_rectify, mean_z] = aa_Arm_Wave_Dealing(data, 1000, i, j, cycle_time);
        [localz_up,peakz_up,data_Resample,...
        levels,RiseT,LoTime1,HiTime1,FallT,LoTime2,HiTime2] = ab_find_key_point(data_Resample,i,j,mean_z);
        feature_look_ = ac_feature_gesture_look(localz_up,peakz_up,data_Resample,...
                                    levels,RiseT,LoTime1,HiTime1,FallT,LoTime2,HiTime2);
        feature_look_ = [i, j, feature_look_];
        feature_look = [feature_look; feature_look_];
        
        i
        j
    end
end

DIR = '/Users/mofan/Documents/master_thesis/4_results/gait_gesture/feature_1look.csv';
dlmwrite(DIR,feature_look)