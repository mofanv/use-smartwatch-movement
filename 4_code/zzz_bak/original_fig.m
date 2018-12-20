% B0B4486E4145 left foot
% B0B4486F003D right foot
clc
clear
file_name={};
file_name{1}='/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/p00/sp3_B0B4486E4145_2018-03-18_19-54-33.csv';

xr = 10.5;
yr = 13;
%%
data=importdata(file_name{1});
A=data(1).data;

TTT=A(:,1);
acc_x=A(:,2);
acc_y=A(:,3);
acc_z=A(:,4);
ang_x=A(:,5);
ang_y=A(:,6);
ang_z=A(:,7);
t=TTT;

frequency=[];
desiredFs=1000;% transfrom frequency to 1000 Hz

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
[Acc_x, T] = resample(acc_x,t,desiredFs);
[Acc_y, T] = resample(acc_y,t,desiredFs);
[Acc_z, T] = resample(acc_z,t,desiredFs);
[Ang_x, T] = resample(ang_x,t,desiredFs);
[Ang_y, T] = resample(ang_y,t,desiredFs);
[Ang_z, T] = resample(ang_z,t,desiredFs);

Acc_x = detrend(Acc_x); %remove trends from data
Acc_y = detrend(Acc_y); %remove trends from data
Acc_z = detrend(Acc_z); %remove trends from data
Ang_x = detrend(Ang_x); %remove trends from data
Ang_y = detrend(Ang_y); %remove trends from data
Ang_z = detrend(Ang_z); %remove trends from data

fc = 10; %cut off frequency
fs = desiredFs; %sampling rate
[b,a] = butter(5,fc/(fs/2));
Accx_filtered = filter(b,a,Acc_x); %filter frequency
Accy_filtered = filter(b,a,Acc_y);
Accz_filtered = filter(b,a,Acc_z);
Angx_filtered = filter(b,a,Ang_x);
Angy_filtered = filter(b,a,Ang_y);
Angz_filtered = filter(b,a,Ang_z);

figure(1)
hold on
plot(T,Accx_filtered,'m-')
plot(T,Accy_filtered,'k-.')
plot(T,Accz_filtered,'b--')
legend('x','y','z')
xlim([xr yr])

figure(2)
hold on
plot(T,Angx_filtered,'m-')
plot(T,Angy_filtered,'k-.')
plot(T,Angz_filtered,'b--')
legend('x','y','z')
xlim([xr yr])