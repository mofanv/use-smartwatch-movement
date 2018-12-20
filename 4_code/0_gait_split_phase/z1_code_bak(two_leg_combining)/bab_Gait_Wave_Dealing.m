function [data_] = bab_Gait_Wave_Dealing(data, Fs)
%% Wave Dealing
A = data.data;

TTT=A(:,1);
acc_x=A(:,2);
acc_y=A(:,3);
acc_z=A(:,4);
ang_x=A(:,5);
ang_y=A(:,6);
ang_z=A(:,7);
t=TTT;

% angle pick
acc_x = baba_Angle_Pick(acc_x);
acc_y = baba_Angle_Pick(acc_y);
acc_z = baba_Angle_Pick(acc_z);
ang_x = baba_Angle_Pick(ang_x);
ang_y = baba_Angle_Pick(ang_y);
ang_z = baba_Angle_Pick(ang_z);


desiredFs = Fs;% transfrom frequency to 1000 Hz

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

fc = 5; %cut off frequency
fs = desiredFs; %sampling rate
[b,a] = butter(5,fc/(fs/2));
Accx_filtered = filter(b,a,Acc_x); %filter frequency
Accy_filtered = filter(b,a,Acc_y);
Accz_filtered = filter(b,a,Acc_z);
Angx_filtered = filter(b,a,Ang_x);
Angy_filtered = filter(b,a,Ang_y);
Angz_filtered = filter(b,a,Ang_z);
%Accx_filtered = Acc_x;
%Accy_filtered = Acc_y;
%Accz_filtered = Acc_z;
%Angx_filtered = Ang_x;
%Angy_filtered = Ang_y;
%Angz_filtered = Ang_z;

%if i == 2
%    Angz_filtered = -Angz_filtered;
%end

data_(:,1) = T;
data_(:,2) = Accx_filtered;
data_(:,3) = Accy_filtered;
data_(:,4) = Accz_filtered;
data_(:,5) = Angx_filtered;
data_(:,6) = Angy_filtered;
data_(:,7) = Angz_filtered;
