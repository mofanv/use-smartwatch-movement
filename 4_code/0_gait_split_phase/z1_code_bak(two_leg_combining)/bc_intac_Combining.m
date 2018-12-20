function [click_gait, B_p, errRate_leg_key, errRate_leg_all] = bc_intac_Combining(stat_angz, offsetTime, click_DIR, i_person)

% unify the time scale
ip_given = bcc_ID_Person_Changing(i_person,'want_given');
intervalT = offsetTime(ip_given, 2);

data = importdata(click_DIR);
B = data(1).data;2
inter_t = B(:,9)/1000 + intervalT;

%%
% find the gait phase that contain the interaction
click_phase = zeros(size(B,1),1);
click_foot = zeros(size(B,1),1);

for i = 1:length(inter_t)
    [idx1, ~] = knnsearch(stat_angz(:,1),inter_t(i),'k',1);
    [idx2, ~] = knnsearch(stat_angz(:,2),inter_t(i),'k',1);
    [idx3, ~] = knnsearch(stat_angz(:,3),inter_t(i),'k',1);
    % select all possible row for dataset
    temp_find = stat_angz((min([idx1,idx2,idx3]) - 1):(max([idx1,idx2,idx3]) + 1),:);
    key = 'go';
    
    % min and max time
    if i == 1  timeMIN = idx1;
    end
    if i == length(inter_t)  timeMAX = idx3;
    end
    
    % which in swing phase or stance phase
    for j=1:size(temp_find,1)
        if (temp_find(j,1) - inter_t(i) <= 0) && (temp_find(j,2) - inter_t(i) > 0) && strcmp(key,'go')
            click_phase(i) = 1;
            click_foot(i) = temp_find(j,4);
            key = 'found';
        end
        if (temp_find(j,2) - inter_t(i) <= 0) && (temp_find(j,3) - inter_t(i) > 0) && strcmp(key,'go')
            click_phase(i) = 2;
            click_foot(i) = temp_find(j,4);
            key = 'found';
        end
    end
    
    % if cannot find, then using 00000
    if strcmp(key,'go')
        click_phase(i) = 0;
        click_foot(i) = 0;
    end
end
click_gait = click_phase + click_foot*10;
%tabulate(click_gait)
%%
ip = repmat(str2double(i_person),length(click_foot),1);
B_p = [B,inter_t,click_foot,click_phase,ip];

format long
%FILE_DIR = '/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed_by_matlab/3_interact_feature_per_phase.csv';
%dlmwrite(FILE_DIR,B_p,'precision', '%.5f');

%% (added) left & right leg - error rate
err = 0;
for i = 2:size(stat_angz, 1)
    if stat_angz(i,4) == stat_angz(i-1,4)
        err = err + 1;
    end
end
errRate_leg_all = err/size(stat_angz, 1);

err = 0;
stat_angzT = stat_angz(timeMIN:timeMAX,:);
for i = 2:size(stat_angzT, 1)
    if stat_angzT(i,4) == stat_angzT(i-1,4)
        err = err + 1;
    end
end
errRate_leg_key = err/size(stat_angzT, 1);


end