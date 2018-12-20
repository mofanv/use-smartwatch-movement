function [localz_up,peakz_up,data_Resample,...
    levels,RiseT,LoTime1,HiTime1,FallT,LoTime2,HiTime2] = ab_find_key_point(data_Resample,i,j,Mean_z)

Fs = 1000;
desiredFs = Fs;
threshold = 100;

T = data_Resample(:,1);
Angz_filtered = data_Resample(:,2);

%%  z coordination data processing (find peak)
% find peak
[peakz_up0,localz_up0] = findpeaks(Angz_filtered,'minpeakdistance',desiredFs*5);
localz_up = localz_up0(Angz_filtered(localz_up0)>(Mean_z + threshold));% Peaks between 
peakz_up = peakz_up0(Angz_filtered(localz_up0)>(Mean_z + threshold));% Peaks between 
[peakz_down0,localz_down0] = findpeaks(-Angz_filtered,'minpeakdistance',desiredFs*5);  %,'minpeakheight',0.05
localz_down = localz_down0(Angz_filtered(localz_down0)<(Mean_z - threshold));% Peaks between 
peakz_down = peakz_down0(Angz_filtered(localz_down0)<(Mean_z - threshold));% Peaks between 

if  (mean(peakz_down0) > Mean_z)
    Angz_filtered = -Angz_filtered;
    Mean_z = -Mean_z;
    localz_up = localz_down; peakz_up = peakz_down;
    localz_down = []; peakz_down = [];
else
    localz_down = []; peakz_down = [];
end

% Extract Features of a Clock Signal
levels = statelevels(Angz_filtered);
levels = levels(1);

[RiseT,LoTime1,HiTime1] = risetime(Angz_filtered,T);
[FallT,LoTime2,HiTime2] = falltime(Angz_filtered,T);

%% plot and check

%figure(i*5+j)
%hold on
%plot(T, Angz_filtered,'blue')
%plot(T(localz_up),peakz_up,'*','color','red')
%plot(T(localz_down),peakz_down,'*','color','green')
%plot([T(1),T(length(T))],[levels(1),levels(1)])

%if length(LoTime1) > 0
%    for LT1 = LoTime1
%        plot([LT1,LT1],[-200,200])
%    end
%end
%if length(LoTime2) > 0
%    for LT2 = LoTime2
%        plot([LT2,LT2],[-200,200])
%    end
%end

end