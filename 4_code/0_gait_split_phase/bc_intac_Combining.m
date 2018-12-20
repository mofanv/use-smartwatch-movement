function [mark, B_p,err_all,err_key, percent] = bc_intac_Combining(stat_angz, offsetTime, click_DIR, i_person, i_sp_num)

% unify the time scale
ip_given = bcc_ID_Person_Changing(i_person,'want_given');
intervalT = offsetTime(ip_given, 2);

data = importdata(click_DIR);
B = data(1).data;
inter_t = B(:,9)/1000 + intervalT;

%%
% find the gait phase that contain the interaction
mark = zeros(size(B,1),1);

for i = 1:length(inter_t)
    [idx1, ~] = knnsearch(stat_angz(:,1),inter_t(i),'k',1);
    if inter_t(i) >= stat_angz(idx1,1)
        mark1 = stat_angz(idx1,3);
        mark2 = stat_angz(idx1+1,3);
    elseif inter_t(i) < stat_angz(idx1,1)
        mark1 = stat_angz(idx1-1,3);
        mark2 = stat_angz(idx1,3);
    end
    
    % min and max time
    if i == 1  timeMIN = idx1;
    end
    if i == length(inter_t)  timeMAX = idx1;
    end
    
    if mark1 == 1 && mark2 == 2     mark_ = 1; % locate in stance 1
    elseif mark1 == 2 && mark2 == 3     mark_ = 2; % locate in stance 2
    elseif mark1 == 3 && mark2 == 4     mark_ = 3; % locate in swing 1
    elseif mark1 == 4 && mark2 == 1     mark_ = 4; % locate in swing 2
    else mark_ = 0;
    end
    
    mark(i) = mark_;
end

%tabulate(mark)
%%
ip = repmat(str2double(i_person),length(mark),1);
isp = repmat(i_sp_num,length(mark),1);
B_p = [B,inter_t,mark,ip,isp];

%% (add) error rate && percent
% all
datM = stat_angz(:,3);
err = 0;
t12 = []; t23 = []; t34 = []; t41 = [];
for i = 2:(length(datM))
    if datM(i-1) == 1 && datM(i) == 2
        t12_ = stat_angz(i,1) - stat_angz(i-1,1); t12 = [t12,t12_];
    elseif datM(i-1) == 2 && datM(i) == 3
        t23_ = stat_angz(i,1) - stat_angz(i-1,1); t23 = [t23,t23_];
    elseif datM(i-1) == 3 && datM(i) == 4
        t34_ = stat_angz(i,1) - stat_angz(i-1,1); t34 = [t34,t34_];
    elseif datM(i-1) == 4 && datM(i) == 1
        t41_ = stat_angz(i,1) - stat_angz(i-1,1); t41 = [t41,t41_];
    else 
        err = err + 1;
    end
end
err_all = err/(length(datM)-2);
t12 = mean(t12); t23 = mean(t23); t34 = mean(t34); t41 = mean(t41);
t1234 = t12 + t23 + t34 + t41;
per12 = t12/t1234; per23 = t23/t1234; per34 = t34/t1234; per41 = t41/t1234;
percent = [per12, per23, per34, per41];

% key
datM = stat_angz(timeMIN:timeMAX,3);
err = 0;
for i = 2:(length(datM)-1)
    if datM(i-1) == 1 && datM(i) == 2 && datM(i+1) == 3
    elseif datM(i-1) == 2 && datM(i) == 3 && datM(i+1) == 4
    elseif datM(i-1) == 3 && datM(i) == 4 && datM(i+1) == 1
    elseif datM(i-1) == 4 && datM(i) == 1 && datM(i+1) == 2
    else 
        err = err + 1;
    end
end
err_key = err/(length(datM)-2);

end