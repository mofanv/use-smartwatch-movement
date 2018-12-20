function [feature_wrist] = cd_feature_gesture_wrist(dat, loc_1st, loc_2nd, loc_3rd)
    
para_time = 0.5;    
para_acc = 0.8;

    loc_1st = [loc_1st, repmat(1,length(loc_1st),1), (1:length(loc_1st))'];
    loc_2nd = [loc_2nd, repmat(2,length(loc_2nd),1), (1:length(loc_2nd))'];
    loc_3rd = [loc_3rd, repmat(3,length(loc_3rd),1), (1:length(loc_3rd))'];
    % mark of loc(1,2,3); mark of motion(1:length)
    loc = [loc_1st;loc_2nd;loc_3rd];
    loc = sortrows(loc);
    
    %% wrist gesture times
    times_wrist = size(loc,1)/3;
    times_wrist = round(times_wrist,0);
    
    %% time up and time down
    % calculate time UP and time DOWN
    timeUP = []; timeDOWN = [];
    angx_changed = 0; angy_changed = 0; angz_changed = 0;
    for i = 2:size(loc,1)
        if loc(i-1,2) == 1 && loc(i,2) == 2
            timeUP_ = loc(i,1) - loc(i-1,1);
            timeUP = [timeUP,timeUP_];
        elseif loc(i-1,2) == 2 && loc(i,2) == 3
            timeDOWN_ = loc(i,1) - loc(i-1,1);
            timeDOWN = [timeDOWN,timeDOWN_];
        end
    end
    
    % filter off data and calculate
    diff_timeUP = abs(timeUP - mean(timeUP));
    thres1 = min(diff_timeUP); thres2 = max(diff_timeUP);
    thres = (thres2 - thres1)*para_time + thres1;
    timeUP_filter = timeUP(diff_timeUP <= thres);
    avg_timeUP = mean(timeUP_filter);
    
    diff_timeDOWN = abs(timeDOWN - mean(timeDOWN));
    thres1 = min(diff_timeDOWN); thres2 = max(diff_timeDOWN);
    thres = (thres2 - thres1)*para_time + thres1;
    timeDOWN_filter = timeDOWN(diff_timeDOWN <= thres);
    avg_timeDOWN = mean(timeDOWN_filter);
    
    %% average acceleration and angle changed
    accUP = []; accDOWN = [];
    for i = 2:size(loc,1)
        if loc(i-1,2) == 1 && loc(i,2) == 2
            idx1 = knnsearch(dat(:,1), loc(i-1,1),'k',1);
            idx2 = knnsearch(dat(:,1), loc(i,1),'k',1);
            
            accx = dat(idx1:idx2,5);
            accy = dat(idx1:idx2,6);
            accz = dat(idx1:idx2,7);
            acc_ = sqrt(accx.^2 + accy.^2 + accz.^2);
            acc_ = mean(acc_);
            accUP = [accUP,acc_];
            
            angx1 = dat(idx1,3); angx2 = dat(idx2,3);
            angx_changed = angx2 - angx1;
            angy1 = dat(idx1,4); angy2 = dat(idx2,4);
            angy_changed = angy2 - angy1;
            angz1 = dat(idx1,2); angz2 = dat(idx2,2);
            angz_changed = angz2 - angz1;
            
        elseif loc(i-1,2) == 2 && loc(i,2) == 3
            idx1 = knnsearch(dat(:,1), loc(i-1,1),'k',1);
            idx2 = knnsearch(dat(:,1), loc(i,1),'k',1);
            accx = dat(idx1:idx2,5);
            accy = dat(idx1:idx2,6);
            accz = dat(idx1:idx2,7);
            acc_ = sqrt(accx.^2 + accy.^2 + accz.^2);
            acc_ = mean(acc_);
            accDOWN = [accDOWN,acc_];
        end
    end
        
    % filter off data and calculate
    diff_accUP = abs(accUP - mean(accUP));
    thres1 = min(diff_accUP); thres2 = max(diff_accUP);
    thres = (thres2 - thres1)*para_acc + thres1;
    accUP_filter = accUP(diff_accUP <= thres);
    avg_accUP = mean(accUP_filter);
    
    diff_accDOWN = abs(accDOWN - mean(accDOWN));
    thres1 = min(diff_accDOWN); thres2 = max(diff_accDOWN);
    thres = (thres2 - thres1)*para_acc + thres1;
    accDOWN_filter = accDOWN(diff_accDOWN <= thres);
    avg_accDOWN = mean(accDOWN_filter);
    
    
    
    %%
    feature_wrist = [times_wrist,avg_timeUP,avg_timeDOWN, avg_accUP, avg_accDOWN,...
                        angx_changed, angy_changed, angz_changed];
end