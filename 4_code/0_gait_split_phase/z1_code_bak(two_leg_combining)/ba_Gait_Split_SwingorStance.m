function[comb_angz, stat_angz, aaa] = ba_Gait_Split_SwingorStance(DIR1, DIR2, i_sp_num)

file_name={};
file_name{1}=DIR1;
file_name{2}=DIR2;
%i_sp_num = 2;
%file_name{1}='/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/p00/sp2_B0B4486E4145_2018-03-20_13-57-05.csv';
%file_name{2}='/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/p00/sp2_B0B4486F003D_2018-03-20_13-57-05.csv';


% Time Scale Compared
data1 = baa_Gait_Time_Scale_Dealing(file_name{1});
data2 = baa_Gait_Time_Scale_Dealing(file_name{2});

% Wave Dealing
data1_Resample = bab_Gait_Wave_Dealing(data1, 1000);
data2_Resample = bab_Gait_Wave_Dealing(data2, 1000);

for i =1:2
    if i == 1
        data_Resample = data1_Resample;
    else
        data_Resample = data2_Resample;
    end
    % Key Point Finding
    [localpz_up,peakz_up,localpz_down,peakz_down,...
        localpz_zeroD,peakz_zeroD,localpz_zeroU,peakz_zeroU] = bac_Gait_KeyPoint_Finding(data_Resample, 1000, i_sp_num);
    % split gait phases by feature points   =q nqSEDRFT  
    phase_angz = bad_SplitGait_using_FeaturePoint(i,i_sp_num,data_Resample,...
                                                    localpz_up,peakz_up,localpz_down,peakz_down,...
                                                    localpz_zeroD,peakz_zeroD,localpz_zeroU,peakz_zeroU);                           
    if i == 1
        left_angz = phase_angz;
    else
        right_angz = phase_angz;
    end
end

% combine the left foot and the right foot
comb_angz = [left_angz;right_angz];
comb_angz = sortrows(comb_angz);
% filter all records with "0" and calculate feature
[stat_angz, aaa, phase_left, phase_right] = bae_Left_Right_Combining_and_Feature(comb_angz);

end
