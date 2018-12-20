function [data_, data_rectify, mean_z] = ca_Arm_Wave_Dealing(data, Fs, i, j, cycle_time)

A = data.data;
TTT=A(:,1);
ang_x=A(:,5);
ang_y=A(:,6);
ang_z=A(:,7);
acc_x=A(:,2);
acc_y=A(:,3);
acc_z=A(:,4);
t=TTT;

%% angle pick z
%mean_z = mean(ang_z(30:round((length(ang_z)/10),0)));
mean_z = 0;
mean_allz = mean(ang_z);
mean_allx = mean(ang_x);

if mean_allx < 0
    ang_z = -ang_z;
end

ang_z = caa_Angle_Pick(ang_z, mean_z);

%% filter
desiredFs = Fs;% transfrom frequency to 1000 Hz
[Ang_z, T] = resample(ang_z,t,desiredFs);
[Ang_x, ~] = resample(ang_x,t,desiredFs);
[Ang_y, ~] = resample(ang_y,t,desiredFs);
[Acc_x, ~] = resample(acc_x,t,desiredFs);
[Acc_y, ~] = resample(acc_y,t,desiredFs);
[Acc_z, ~] = resample(acc_z,t,desiredFs);

fc_ang = aab_Fs_calculate(i, j, cycle_time); %cut off frequency
fs = desiredFs; %sampling rate
[b,a] = butter(5,fc_ang/(fs/2));
Angz_filtered = filter(b,a,Ang_z);
Angx_filtered = filter(b,a,Ang_x);
Angy_filtered = filter(b,a,Ang_y);

fc_azz = aab_Fs_calculate(i, j, cycle_time)*30; %cut off frequency
fs = desiredFs; %sampling rate
[b,a] = butter(5,fc_azz/(fs/2));
Accx_filtered = filter(b,a,Acc_x);
Accy_filtered = filter(b,a,Acc_y);
Accz_filtered = filter(b,a,Acc_z);

%finddelay(s1,s2)
threshold = -1000;
index = find(Angz_filtered >= (mean_z + threshold));

data_(:,1) = T(index,:);
data_(:,2) = Angz_filtered(index,:);
data_(:,3) = Angx_filtered(index,:);
data_(:,4) = Angy_filtered(index,:);
data_(:,5) = Accx_filtered(index,:);
data_(:,6) = Accy_filtered(index,:);
data_(:,7) = Accz_filtered(index,:);

data_ = data_(200:size(data_,1),:); % not from zero point

data_rectify(:,1) = TTT; %%%%%%%%%%%%%%%%%%
data_rectify(:,2) = ang_z; %%%%%%%%%%%%%%%%%%
end