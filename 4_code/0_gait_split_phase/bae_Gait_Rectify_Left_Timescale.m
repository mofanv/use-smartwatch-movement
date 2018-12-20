function[left_angz, right_angz, data_plot1, data_plot2, cycle_time] = bae_Gait_Rectify_Left_Timescale(left_angz, right_angz, ...
                                                                            i_person, i_sp_num, data_plot1,data_plot2)

peek_left = left_angz(left_angz(:,3) == 1,:);
peek_right = right_angz(right_angz(:,3) == 1,:);
trough_left = left_angz(left_angz(:,3) == 2,:);
trough_right = right_angz(right_angz(:,3) == 2,:);

%% mean value of gait cycle time (by peek)
mean_peek_timeL = [];
for i = 2:size(peek_left,1)
    peek_time = peek_left(i,1) - peek_left(i-1,1);
    mean_peek_timeL = [mean_peek_timeL, peek_time];
end
mean_peek_timeL = mean(mean_peek_timeL);

mean_peek_timeR = [];
for i = 2:size(peek_right,1)
    peek_time = peek_right(i,1) - peek_right(i-1,1);
    mean_peek_timeR = [mean_peek_timeR, peek_time];
end
mean_peek_timeR = mean(mean_peek_timeR);
mean_peek_time = (mean_peek_timeL + mean_peek_timeR) / 4;
%% mean value of gait cycle time (by trough)
mean_trough_timeL = [];
for i = 2:size(trough_left,1)
    trough_time = trough_left(i,1) - trough_left(i-1,1);
    mean_trough_timeL = [mean_trough_timeL, trough_time];
end
mean_trough_timeL = mean(mean_trough_timeL);

mean_trough_timeR = [];
for i = 2:size(trough_right,1)
    trough_time = trough_right(i,1) - trough_right(i-1,1);
    mean_trough_timeR = [mean_trough_timeR, trough_time];
end
mean_trough_timeR = mean(mean_trough_timeR);
mean_trough_time = (mean_trough_timeL + mean_trough_timeR) / 4;
%% calculate the offset of timescale
peek_left(:,3) = 1; peek_right(:,3) = 2;
peek = [peek_left; peek_right];
peek = sortrows(peek);

real_peek_time = [];
for i = 2:(size(peek,1)-1) % peek right locate in two peek left
    if peek(i-1,3) == 1 && peek(i+1,3) == 1 && peek(i,3) == 2
        time_temp = peek(i,1) - peek(i-1,1);
        real_peek_time = [real_peek_time,time_temp];
    end
end
real_peek_time = mean(real_peek_time);

cycle_time = mean_trough_time + mean_peek_time;
mean_peek_time = cycle_time/2; % rectify mean peek time
offset_time = real_peek_time - mean_peek_time;

%% exception
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ipsp = strcat(i_person,'_',num2str(i_sp_num));
if strcmp(ipsp,'4_3') || strcmp(ipsp,'9_3')
    offset_time = mean_peek_time;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% rectify time scale
left_angz(:,1) = left_angz(:,1) + offset_time/2;
right_angz(:,1) = right_angz(:,1) - offset_time/2;

data_plot1(:,1) = data_plot1(:,1) + offset_time/2;
data_plot2(:,1) = data_plot2(:,1) - offset_time/2;

end