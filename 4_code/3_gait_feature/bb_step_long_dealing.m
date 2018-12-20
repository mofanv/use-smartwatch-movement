function [T, Ay_filtered] = bb_step_long_dealing(A)
%% pro-precessing
TTT=A(:,1);
t=TTT+1;

A_xxx=A(:,6);
ax=A_xxx;

desiredFs=100;% 100Hz

[Ax, T] = resample(ax,t,desiredFs);
dt_Ax=detrend(Ax); %remove trends from data

%butterworth, a fifthorder, lowpass Butterworth filter with a 10Hz cut-off frequency
fc = 0.5; %cut off frequency
fs = 100; %sampling rate
[b,a] = butter(5,fc/(fs/2));
Ay_filtered = filter(b,a,dt_Ax);
end