% relative time of every phase of gait cycle
temp = A(1,1) - A(1,2);

% unify the time scale
% average time between computer system time and watch system is: 17.00999993748
diff_t = 17.00999993748;
file_name_inter = '/Users/mofan/Documents/master_thesis/gait_analysis/4_data/aaa_data/No1_Sp3_click.txt';
data = importdata(file_name_inter);
B = data(1).data;
inter_t = (B(:,9)/1000 + diff_t) - temp;

%%
% find the gait phase that contain the interaction
click_phase = zeros(size(B,1),1);
click_foot = zeros(size(B,1),1);

for i = 1:length(inter_t)
    [idx1, ~] = knnsearch(stat_angz(:,1),inter_t(i),'k',1);
    [idx2, ~] = knnsearch(stat_angz(:,2),inter_t(i),'k',1);
    [idx3, ~] = knnsearch(stat_angz(:,3),inter_t(i),'k',1);
    temp_find = stat_angz((min([idx1,idx2,idx3]) - 1):(max([idx1,idx2,idx3]) + 1),:);

    for j=1:size(temp_find,1)
        if (temp_find(j,1) - inter_t(i) <= 0) & (temp_find(j,2) - inter_t(i) > 0)
            click_phase(i) = 1;
            click_foot(i) = temp_find(j,4);
        end
        if (temp_find(j,2) - inter_t(i) <= 0) & (temp_find(j,3) - inter_t(i) > 0)
            click_phase(i) = 2;
            click_foot(i) = temp_find(j,4);
        end
    end
end
click_gait = click_phase + click_foot*10;
tabulate(click_gait)

%%
B_p = [B,(B(:,9)/1000 + diff_t),click_foot,click_phase];
format long
FILE_DIR = '/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed_by_matlab/3_interact_feature_per_phase.csv';
dlmwrite(FILE_DIR,B_p,'precision', '%.5f');