function [data_, data_rectify, mean_z] = aa_Arm_Wave_Dealing(data, Fs, i, j, cycle_time)

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
mean_z = mean(ang_z(30:round((length(ang_z)/4),0)));
if (i == 4) || (i == 18 && j == 4)
    ang_z = ang_z;
else
    ang_z = aaa_Angle_Pick(ang_z, mean_z);
end

data_rectify(:,1) = TTT;
data_rectify(:,2) = ang_z;
data_rectify(:,3) = ang_x;
data_rectify(:,4) = ang_y;

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

fc_azz = aab_Fs_calculate(i, j, cycle_time)*20; %cut off frequency
fs = desiredFs; %sampling rate
[b,a] = butter(5,fc_azz/(fs/2));
Accx_filtered = filter(b,a,Acc_x);
Accy_filtered = filter(b,a,Acc_y);
Accz_filtered = filter(b,a,Acc_z);

%finddelay(s1,s2)
data_(:,1) = T(10000:length(Angz_filtered),:);
data_(:,2) = Angz_filtered(10000:length(Angz_filtered),:);
data_(:,3) = Angx_filtered(10000:length(Angz_filtered),:);
data_(:,4) = Angy_filtered(10000:length(Angz_filtered),:);
data_(:,5) = Accx_filtered(10000:length(Angz_filtered),:);
data_(:,6) = Accy_filtered(10000:length(Angz_filtered),:);
data_(:,7) = Accz_filtered(10000:length(Angz_filtered),:);

end