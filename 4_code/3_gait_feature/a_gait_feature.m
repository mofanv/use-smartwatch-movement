clc
clear

key1 = '1_look'; key2 = '2_touch'; key3 = '4_wrist';
cycle_dis = 18;

for key_ = 1:3
    if key_ == 1        key = key1;
    elseif key_ == 2        key = key2;
    elseif key_ == 3        key = key3;
    end
    
feature_gait = [];

%np = [0:7,9:11,13:16,20,21];
for i = [0:1,3:13,15:21,24,29,31:32,35:36,38:44]
    for j = 2:5
   %i = 6; j = 4;
    if ~(((i == 7) && (j==5)) ...
            || ((i == 6) && (j==4)) ...
            || ((i == 10) && (j==3)) || ((i == 11) && (j==4)))
               % feature of left leg
        DIR = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/',key,'/p',...
                num2str(i),'_sp',num2str(j),'_left_leg.csv');
        dat1 = dlmread(DIR);
        dat1(:,1) = dat1(:,1) - dat1(1,1);
        [feature_gait_left, dat_left] = ab_gait_feature_calcuate(dat1);
        
        % feature of right leg
        DIR = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/1_look/p',...
                num2str(i),'_sp',num2str(j),'_right_leg.csv');
        dat2 = dlmread(DIR);
        dat2(:,1) = dat2(:,1) - dat2(1,1);
        [feature_gait_right, dat_right] = ab_gait_feature_calcuate(dat2);
        
        %% autocorrelation coefficient (Step symmetry)
        symmetry = ac_gait_symmetry(dat_left, dat_right);
        
        % mean value of left and right
        feature_gait_ = (feature_gait_left + feature_gait_right)/2;
        feature_gait_ = [i,j,feature_gait_,symmetry];
        feature_gait = [feature_gait;feature_gait_];
        i
        j
    end
    end
end

DIR = strcat('/Users/mofan/Documents/master_thesis/4_results/finial_gait_feature/gait_feature_',key,'.csv');
dlmwrite(DIR,feature_gait)

end