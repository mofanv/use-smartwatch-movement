function[stat_angz, abs_stat_angz, aaa, cycle_time] = ba_Gait_Split_SwingorStance(DIR1, DIR2, i_person, i_sp_num, debug_sp)

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
    [phase_angz, plot_z] = bad_SplitGait_using_FeaturePoint(i, i_person, i_sp_num, data_Resample,...
                                                    localpz_up,peakz_up,localpz_down,peakz_down,...
                                                    localpz_zeroD,peakz_zeroD,localpz_zeroU,peakz_zeroU);                               
    if i == 1
        left_angz = phase_angz;
        data_plot1 = plot_z;
    elseif i == 2
        right_angz = phase_angz;
        data_plot2 = plot_z;
    end
end

% rectify timescale of left and right
[left_angz, right_angz, data_plot1, data_plot2, cycle_time] = bae_Gait_Rectify_Left_Timescale(left_angz, right_angz, ...
                                                            i_person, i_sp_num, data_plot1, data_plot2);

% filter all records with "0" and calculate feature
[stat_angz, aaa] = baf_Left_Right_Combining_and_Feature(left_angz, right_angz, i_sp_num, data_plot1, data_plot2, debug_sp);

abs_stat_angz = stat_angz;
abs_stat_angz(:,1) = stat_angz(:,1) - stat_angz(1,1);

%end

end
