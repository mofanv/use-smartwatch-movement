function [stepnum, steplong] = bd_feature_step_number(T, dat_y,  start_time, end_time, distance)
%% pro-precessing
TTT=T;
t=TTT+1;

ax=dat_y;

desiredFs=100;% 100Hz

[Ax, T] = resample(ax,t,desiredFs);
dt_Ax=detrend(Ax); %remove trends from data

%butterworth, a fifthorder, lowpass Butterworth filter with a 10Hz cut-off frequency
fc = 1; %cut off frequency
fs = 100; %sampling rate
[b,a] = butter(5,fc/(fs/2));
Ax_filtered = filter(b,a,dt_Ax);

startp = knnsearch(T, start_time, 'k', 1);
endp = knnsearch(T, end_time, 'k', 1);
T = T(startp:endp);
Ax_filtered = Ax_filtered(startp:endp);
%% find peak
[peakx,localx] = findpeaks(Ax_filtered,'minpeakdistance',60,'minpeakheight',0.02);

intervalx=[];
 for i=1:(length(localx)-1)
    intervalx(i)=T(localx(i+1))-T(localx(i)); % step time
 end
intervalx;
peakx;

%% stepnum, steplong
steptime = mean(intervalx);
stepnum = ((t(length(t))-t(1)) / steptime) * 2;
steplong = distance / stepnum;

end