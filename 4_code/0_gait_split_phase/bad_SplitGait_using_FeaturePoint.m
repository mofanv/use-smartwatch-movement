function [phase_angz, plot_z] = bad_SplitGait_using_FeaturePoint(n, i_person, i_sp_num, data_Resample,...
                                                           localpz_up,peakz_up,localpz_down,peakz_down,...
                                                           localpz_zeroD,peakz_zeroD,localpz_zeroU,peakz_zeroU)
% use zero1 or zero2 (the zero point)
local_temp = [localpz_up; localpz_down];
peak_temp = [peakz_up; peakz_down];
nz_upT = repmat(1,length(localpz_up),1);
nz_downT = repmat(2,length(localpz_down),1);
phase_temp = [nz_upT; nz_downT];

result_temp = [local_temp,peak_temp,phase_temp];
result_temp = sortrows(result_temp);

% the difference value between up and down
diff_temp = [];
for i = 2:size(result_temp,1)
    if (result_temp(i,3) == 2) && (result_temp(i-1,3) == 1) % down - up
        diff_ = result_temp(i,1) - result_temp(i-1,1); 
        diff_temp = [diff_temp, diff_];
    end
end
sum_diff = sum(diff_temp);
alltime = result_temp(size(result_temp,1),1) - result_temp(1,1);
rate_diff = sum_diff/alltime;

if rate_diff > 0.5
    localpz_zero = localpz_zeroU; peakz_zero = peakz_zeroU;
    result_temp(:,3) = 3 - result_temp(:,3); % 2 to 1; 1 to 2
    result_temp(:,2) = - result_temp(:,2);
    plot_z = - data_Resample(:,7);
    localpz_zero_add = localpz_zeroD; peakz_zero_add = peakz_zeroD;
else
    plot_z = data_Resample(:,7);
    localpz_zero = localpz_zeroD; peakz_zero = peakz_zeroD;
    localpz_zero_add = localpz_zeroU; peakz_zero_add = peakz_zeroU;
end

%% exception
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ipsp = strcat(i_person,'_',num2str(i_sp_num));
if strcmp(ipsp,'13_4') && (n == 2)
    localpz_zero = localpz_zeroU; peakz_zero = peakz_zeroU;
    result_temp(:,3) = 3 - result_temp(:,3); % 2 to 1; 1 to 2
    result_temp(:,2) = - result_temp(:,2);
    plot_z = - data_Resample(:,7);
    localpz_zero_add = localpz_zeroD; peakz_zero_add = peakz_zeroD;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot_z = [data_Resample(:,1), plot_z]; % data used to plot
phase_angz = result_temp;

end