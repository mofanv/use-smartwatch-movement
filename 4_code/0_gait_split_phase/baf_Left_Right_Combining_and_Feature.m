function[stat_angz, aaa] = baf_Left_Right_Combining_and_Feature(left_angz, right_angz,i_sp_num, data_plot1, data_plot2, debug_sp)
%% combine all feature points
left_angz(left_angz(:,3) == 1,3) = 4; % mark left peek
left_angz(left_angz(:,3) == 2,3) = 1; % mark left trough
right_angz(right_angz(:,3) == 2,3) = 3; % mark right trough
right_angz(right_angz(:,3) == 1,3) = 2; % mark right peek
comb_angz = [left_angz; right_angz];
comb_angz = sortrows(comb_angz);

%% calculate period time of every gait phase
stance1_time = [];
stance2_time = [];
swing1_time = [];
swing2_time = [];
for i = 2:size(comb_angz,1)
    if comb_angz(i-1,3) == 1 && comb_angz(i,3) == 2
        stance1_time_ = comb_angz(i,1) - comb_angz(i-1,1);
        stance1_time = [stance1_time,stance1_time_];
    end
    if comb_angz(i-1,3) == 2 && comb_angz(i,3) == 3
        stance2_time_ = comb_angz(i,1) - comb_angz(i-1,1);
        stance2_time = [stance2_time,stance2_time_];
    end
    if comb_angz(i-1,3) == 3 && comb_angz(i,3) == 4
        swing1_time_ = comb_angz(i,1) - comb_angz(i-1,1);
        swing1_time = [swing1_time,swing1_time_];
    end
    if comb_angz(i-1,3) == 4 && comb_angz(i,3) == 1
        swing2_time_ = comb_angz(i,1) - comb_angz(i-1,1);
        swing2_time = [swing2_time,swing2_time_];
    end
end

stat_angz = comb_angz;

%%
sd1 = std(stance1_time);
sd2 = std(stance2_time);
sd3 = std(swing1_time);
sd4 = std(swing2_time);

stance1_time = mean(stance1_time);
stance2_time = mean(stance2_time);
swing1_time = mean(swing1_time);
swing2_time = mean(swing2_time);

aaa = [[stance1_time,sd1];[stance2_time,sd2];[swing1_time,sd3];[swing2_time,sd4]];

%% plot
if i_sp_num == debug_sp
    indexL_trough = find(left_angz(:,3) == 1);
    indexR_peek = find(right_angz(:,3) == 2);
    indexR_trough = find(right_angz(:,3) == 3);
    indexL_peek = find(left_angz(:,3) == 4);

    figure(i_sp_num)
    hold on
    plot(data_plot1(:,1),data_plot1(:,2),'b-')
    plot(data_plot2(:,1),data_plot2(:,2),'m--')
    plot(left_angz(indexL_trough,1),left_angz(indexL_trough,2),'*','color','black')
    plot(left_angz(indexL_peek,1),left_angz(indexL_peek,2),'*','color','red')
    plot(right_angz(indexR_peek,1),right_angz(indexR_peek,2),'o','color','red')
    plot(right_angz(indexR_trough,1),right_angz(indexR_trough,2),'o','color','black')
    legend('left','right')
    xlim([data_plot1(105000,1) data_plot1(108000,1)])
    ylim([-100 100])
end
end