function[stat_angz, aaa, phase_left, phase_right] = bae_Left_Right_Combining_and_Feature(comb_angz)
%% filter all records with "0"
stat_angz = comb_angz;
ntemp=[]; j=1;
for i=1:length(stat_angz)
    if min(stat_angz(i,:)) == 0
        ntemp(j) = i; j = j+1;
    end
end
stat_angz(ntemp',:) = [];

%% back '0' with 5 adjacent value (mean)
diff_zero_up = mean(stat_angz(3) - stat_angz(2));
diff_up_down = mean(stat_angz(2) - stat_angz(1));
mark = 0;
zero_num = 0;
for i = 1:size(comb_angz,1)
    % delete all infront '0' in the first con
    if mark == 0 && comb_angz(i,1) == 0
        zero_num = zero_num + 1;
    else
        mark = 1;
        if comb_angz(i,1) == 0  comb_angz(i,1) = comb_angz(i,2) - diff_up_down;
        end
        if comb_angz(i,2) == 0  comb_angz(i,2) = ...
                           ((comb_angz(i,3)-diff_zero_up) + (comb_angz(i,1)+diff_up_down)) / 2;
        end
        if comb_angz(i,3) == 0  comb_angz(i,3) = comb_angz(i,2) + diff_zero_up;
        end
    end
end
 
%% again filter all records with "0"
stat_angz = comb_angz((zero_num+1):size(comb_angz,1),:);

%% left and right joint-point
%for i = 2:size(stat_angz,1)
%    meanJOINT = (stat_angz(i,1) + stat_angz(i-1,3)) / 2;
%    stat_angz(i,1) = meanJOINT;
%    stat_angz(i-1,3) = meanJOINT;
%end

%% calculate period time of every gait phases
swing_time = stat_angz(:,2) - stat_angz(:,1);
loading_time = stat_angz(:,3) - stat_angz(:,2);
phase_time = [swing_time,loading_time];

foot_idx = stat_angz(:,4);
left_idx = find(foot_idx == 1);
right_idx = find(foot_idx == 2);

phase_left = phase_time(left_idx,:); 
phase_right = phase_time(right_idx,:);

%csvwrite('/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed_by_matlab/phase_left.csv',phase_left);
%csvwrite('/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed_by_matlab/phase_right.csv',phase_right);

aaa = [mean(phase_left(:,1)),std(phase_left(:,1)),mean(phase_left(:,2)),std(phase_left(:,2))];
bbb = [mean(phase_right(:,1)),std(phase_right(:,1)),mean(phase_right(:,2)),std(phase_right(:,2))];
aaa = [aaa;bbb];

end