function [feature_look] = ac_feature_gesture_look(localz_up,peakz_up,data_Resample,...
                                    levels,RiseT,LoTime1,HiTime1,FallT,LoTime2,HiTime2)
                                
%% feature time
% rise time of look gesture
rise_time = mean(RiseT); 
% fall time of look gesture
fall_time = mean(FallT); 
% time of the whole period of look gesture
length_new = min(length(LoTime1),length(LoTime2));
if length(LoTime1) ~= length(LoTime2)
    LoTime1 = LoTime1(1:length_new);
    LoTime2 = LoTime2(1:length_new);
end
all_time = mean(LoTime2 - LoTime1);

%% feature angle
mean_time = (LoTime1+LoTime2)/2;
T = data_Resample(:,1);
angle_z = data_Resample(:,2);
angle_x = data_Resample(:,3);
angle_y = data_Resample(:,4);

% high point used mean time
LEN = length(mean_time);
if LEN > 0
    for i = 1:LEN
        [idx, ~] = knnsearch(T,mean_time(i),'k',1);
        angHX(i) = angle_x(idx); % angle of high point
        angHY(i) = angle_y(idx);
        angHZ(i) = angle_z(idx);
    end
end
angHX = mean(angHX);
angHY = mean(angHY);
angHZ = mean(angHZ);

% high point used peek
for i = 1:length(peakz_up)
    [idx, ~] = knnsearch(T,localz_up(i),'k',1);
    angHX_peek(i) = angle_x(idx); % angle of high point
    angHY_peek(i) = angle_y(idx);
    angHZ_peek(i) = angle_z(idx);
end

% low point used levels
LEN = length(LoTime1);
if LEN > 0
    for i = 1:LEN
        [idx, ~] = knnsearch(T,LoTime1(i),'k',1);
        angLX(i) = angle_x(idx); % angle of low point
        angLY(i) = angle_y(idx);
        angLZ(i) = angle_z(idx);
    end
end
angLX = mean(angLX);
angLY = mean(angLY);
angLZ = mean(angLZ);

angX_changed = angHX - angLX;
angY_changed = angHY - angLY;
angZ_changed = angHZ - angLZ;

%% feature acceleration
accleration_x = data_Resample(:,5);
accleration_y = data_Resample(:,6);
accleration_z = data_Resample(:,7);
accxyz = sqrt(accleration_x.^2 + accleration_y.^2 + accleration_z.^2);

% arm up (mean acceleration)
LEN = length(LoTime1);
if LEN > 0
    for i = 1:LEN
        [idx1, ~] = knnsearch(T,LoTime1(i),'k',1);
        [idx2, ~] = knnsearch(T,HiTime1(i),'k',1);
        accxyzUP(i) = mean(accxyz(idx1:idx2));
    end
end
accxyzUP = mean(accxyzUP);

% arm down (mean acceleration)
LEN = length(LoTime2);
if LEN > 0
    for i = 1:LEN
        [idx1, ~] = knnsearch(T,LoTime2(i),'k',1);
        [idx2, ~] = knnsearch(T,HiTime2(i),'k',1);
        accxyzDOWN(i) = mean(accxyz(idx2:idx1));
    end
end
accxyzDOWN = mean(accxyzDOWN);

feature_look = [all_time, rise_time, fall_time,angX_changed, angY_changed, angZ_changed,accxyzUP, accxyzDOWN, length_new];

end