function [start_time, end_time, distance] = bc_feature_distance(T,dat_y,cycle_dis,i_,j_)
%% filter first several seconds
filtertime = 5; %seconds
idx_start = (filtertime-1)*100+1;

original_len = length(T);
T = T(idx_start:original_len);
dat_y = dat_y(idx_start:original_len);
new_len =  length(T);

% peak added
T_ = (T(2)-T(1)) * [1:3000]' + T(new_len);
T = [T;T_];
dat_y_ = dat_y(new_len) * repmat(1,3000,1);
dat_y_(2500) = 200;
dat_y = [dat_y;dat_y_];

%% find zero point
[peakx, localx] = findpeaks(dat_y,'minpeakdistance',800,'minpeakheight',80);

timepoint = T(localx);
zeropoint = dat_y(localx);

%% combine and delete
T = T(1:new_len); % return
dat_y = dat_y(1:new_len); % return

if length(timepoint) > 1
    mark = zeros(length(timepoint),1);
    for i = 2:length(timepoint)
        if timepoint(i)-timepoint(i-1) <= 5     % 2 seconds
            mark(i) = 1;
        end
    end
    mark = 1 - mark;
    mark = mark(1:(length(mark)-1));
    idx_de = find(mark == 1);
    timepoint = timepoint(idx_de);
    zeropoint = zeropoint(idx_de);
end

%% angle and distance
if length(timepoint) > 1
    start_time = timepoint(1);
    end_time = timepoint(length(timepoint));
    cyclenum = length(timepoint-1);
else
    start_time = T(1);
    end_time = T(length(T));
    start_angle = dat_y(1);
    end_angle = dat_y(length(dat_y));
    angle_changed = end_angle - start_angle;
    
    if length(timepoint) == 1
        cyclenum = angle_changed/360 + 1;
    end
    if isempty(timepoint)
        cyclenum = angle_changed/360;
    end
end

distance = cycle_dis * cyclenum;
%% plot
%figure(i_*5+j_)
%hold on
%plot(T, dat_y)
%plot(timepoint, zeropoint,'*')
end