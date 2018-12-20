function [feature, Ax_filtered] = ab_gait_feature_calcuate(A)

%file_name='/Users/mofan/Documents/master_thesis/gait_analysis/4_data/CSV_FILE/p1/B0B4486E4145_2017-11-19_13-08-04.csv';
%data=importdata(file_name);
%A=data(1).data;

%% pro-precessing
TTT=A(:,1);
t=TTT+1;

A_xxx=A(:,3); 
ax=A_xxx;

frequency=[];
hold on
desiredFs=100;% 100Hz

[Ax, T] = resample(ax,t,desiredFs);
dt_Ax=detrend(Ax); %remove trends from data

%butterworth, a fifthorder, lowpass Butterworth filter with a 10Hz cut-off frequency
fc = 10; %cut off frequency
fs = 100; %sampling rate
[b,a] = butter(5,fc/(fs/2));
Ax_filtered = filter(b,a,dt_Ax);
 
%% find peak
[peakx,localx] = findpeaks(Ax_filtered,'minpeakdistance',60,'minpeakheight',0.2);

intervalx=[];
 for i=1:(length(localx)-1)
    intervalx(i)=T(localx(i+1))-T(localx(i)); % step time
 end
intervalx;
peakx;

%% frequency
frequency(1)=sf(Ax_filtered);
 
%% max min mean std (RMS of acceleration)
maxvalue(1)=max(Ax_filtered);
minvalue(1)=min(Ax_filtered);
meanvalue(1)=mean(Ax_filtered);
stdvalue(1)=std(Ax_filtered);
rmsvalue(1)=rms(Ax_filtered);

%% inter-stride amplitude variability
ampvar(1)=std(peakx);

%% Step variability
steptime(1)=mean(intervalx);
frequency(1) = 1/steptime(1);

stepstd(1)=std(intervalx);
stepcv(1)=stepstd(1)/steptime(1);
 
localpx=(localx-1)/100+T(1);

%% autocorrelation coefficient (Step regularity)
[autocorx,lags] = xcorr(Ax_filtered,500,'coeff');
[peakarx,localarx,w,p] = findpeaks(autocorx);
peakarx = sort(peakarx);
ac = peakarx(length(peakarx)-1);

%% Step symmetry
%acx1 = max(autocorx(480+floor(100/frequency(1)):520+floor(100/frequency(1))));
%acx2 = max(autocorx(480+floor(200/frequency(1)):520+floor(200/frequency(1))));
%symmetryx = acx1/acx2;

%% Harmonic raio
for hix=1:20
harmonicx(hix)=0;
for jx=1:length(T)-1 %
harmonicx(hix)=harmonicx(hix) + ...
    Ax_filtered(jx) * sin(hix*pi*frequency(1)*T(jx)) * (T(jx+1)-T(jx));%?
end
end
harmonicx=abs(harmonicx);%
%plot(har)
%bar(har)
for hx=1:10
oddx(hx)=harmonicx(2*hx-1);
evenx(hx)=harmonicx(2*hx);
end
harmonicrx=sum(evenx)/sum(oddx);

%% plot
%subplot(431)

%hold on
%plot(T,Ax_filtered,'color','blue')
%plot(localpx,peakx,'*','color','red')
%legend('Original','Peak')
%ylim([-2 2])
%subplot(434)

%plot(lags/100,autocorx)
%xlabel('Lag (s)')
%ylabel('AutocorrelationX')
%axis([-4 4 -0.8 1.1])
%subplot(4,3,7)

%plot(intervalx)
%xlabel('step count')
%ylabel('step time')
%ylim([0.3 4])

feature = [steptime/2,frequency,rmsvalue,ampvar,stepcv,ac,harmonicrx];
end