clc
clear

cycle_time = dlmread('/Users/mofan/Documents/master_thesis/4_results/gait/phase_time(ALL).csv');
feature_wrist = [];

% error: 0,5,6,9,10,11,12,13,15,16,17,18,19,20
% zero point(x): 6,7,9,10,11,12,16,17,18,19,20(calculate the acceleration)
% zero point(z): 1,3,4,7,8,21 (calculate the angle)
%[0:1,3:13,15:21,23:25,29,31:32,35:36,38:44]
np = [0:1,3:13,15:21,23:24,29,31:32,35:36,38:44]
npx = [6,7,9,10,11,12,17,18,19,20];%16
npz = [1,3,4,7,8,21];

for i = np
    for j = 1:5
        DIR = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/4_wrist/p',...
                num2str(i),'_sp',num2str(j),'_left_arm.csv');

        dat = dlmread(DIR);
        data.data = dat;
        thr_inter = 40; % interact threshold
        [data_Resample, data_rectify, mean_z] = ca_Arm_Wave_Dealing(data, 1000, i, j, cycle_time);
        if ~isempty(find(npx == i,1))
            [data_Resample, loc_1st, loc_2nd, loc_3rd] = cb_find_key_point_x(data_Resample,i,j);
        elseif ~isempty(find(npz == i,1))
            [data_Resample, loc_1st, loc_2nd, loc_3rd] = cc_find_key_point_z(data_Resample,i,j);
        else
            loc_1st = []; loc_2nd = []; loc_3rd = [];
        end
        
        feature_wrist_ = cd_feature_gesture_wrist(data_Resample, loc_1st, loc_2nd, loc_3rd);
        
        feature_wrist_ = [i, j, feature_wrist_];
        feature_wrist = [feature_wrist; feature_wrist_];
        i
        j
    end
end

DIR = '/Users/mofan/Documents/master_thesis/4_results/gait_gesture/feature_4wrist.csv';
dlmwrite(DIR,feature_wrist)