% B0B4486E4145 left foot
% B0B4486F003D right foot
clc
clear
file_name={};

file_name{1}='/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/p00/sp3_B0B4486E4145_2018-03-18_19-54-33.csv';
file_name{2}='/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/p00/sp3_B0B4486F003D_2018-03-18_19-54-33.csv';
%No1_Sp3_click

%file_name{1}='/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed/B0B4486E4145_2017-11-19_15-45-02.csv';
%file_name{2}='/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed/B0B4486F003D_2017-11-19_15-45-02.csv';
%No3_Sp2_click

%file_name{1}='/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed/B0B4486E4145_2017-11-19_13-16-49.csv';
%file_name{2}='/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed/B0B4486F003D_2017-11-19_13-16-49.csv';
%No1_Sp4_click

%%
for n=1:2 % initially processing both left and right foot
data=importdata(file_name{n});
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

%dt_accx = detrend(Acc_x); %remove trends from data
%dt_accy = detrend(Acc_y); %remove trends from data
%dt_accz = detrend(Acc_z); %remove trends from data
%dt_angx = detrend(Ang_x); %remove trends from data
%dt_angy = detrend(Ang_y); %remove trends from data
%dt_angz = detrend(Ang_z); %remove trends from data

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

Mean_x = mean(Angx_filtered(1:10000));
if abs(max(Angx_filtered(1:3000)) - min(Angx_filtered(1:3000))) < 5
    Mean_z = Angz_filtered(1:3000);
else
    Mean_z = 0;
end


%%  x coordination data processing (find peak)
% find peak
threshold_X_hei = 1;
[peakx_up0,localx_up0] = findpeaks(Angx_filtered,'minpeakdistance',desiredFs/2); %,'minpeakheight',0.05
localx_up = localx_up0(Angx_filtered(localx_up0)>(Mean_x+threshold_X_hei));% Peaks between 
peakx_up = peakx_up0(Angx_filtered(localx_up0)>(Mean_x+threshold_X_hei));% Peaks between 
[peakx_down0,localx_down0] = findpeaks(-Angx_filtered,'minpeakdistance',desiredFs/2);  %,'minpeakheight',0.05
localx_down = localx_down0(Angx_filtered(localx_down0)<(Mean_x-threshold_X_hei));% Peaks between 
peakx_down = peakx_down0(Angx_filtered(localx_down0)<(Mean_x-threshold_X_hei));% Peaks between 

localpx_up=(localx_up-1)/desiredFs+T(1);
localpx_down=(localx_down-1)/desiredFs+T(1);
peakx_down= -peakx_down;

% find zero point
result1 = ((Mean_x-3) < Angx_filtered);
result2 = (Angx_filtered < (Mean_x+3));
result = result1 & result2;
equal_index = find(result == 1);

index0=[]; k=1;
temp=[]; j=1;
for i=1:length(equal_index)-1
    if equal_index(i)+1 == equal_index(i+1)
        j = j+1;
    end
    if equal_index(i)+1 ~= equal_index(i+1)
        temp = equal_index((i-j+1):i);
        if Angx_filtered(equal_index(i)) <= Angx_filtered(equal_index(i)+1)
            index0(k) = round(median(temp));
            k = k+1;
        end
        temp = [];j = 1;
    end
end

localpx_zero = T(index0);
peakx_zero = Angx_filtered(index0);

%%  z coordination data processing (find peak)
% find peak
threshold_Z_hei = 10;
[peakz_up0,localz_up0] = findpeaks(Angz_filtered,'minpeakdistance',desiredFs/2);    %,'minpeakheight',0.05
localz_up = localz_up0(Angz_filtered(localz_up0)>(Mean_z+threshold_Z_hei));% Peaks between 
peakz_up = peakz_up0(Angz_filtered(localz_up0)>(Mean_z+threshold_Z_hei));% Peaks between 
[peakz_down0,localz_down0] = findpeaks(-Angz_filtered,'minpeakdistance',desiredFs/2);  %,'minpeakheight',0.05
localz_down = localz_down0(Angz_filtered(localz_down0)<(Mean_z-threshold_Z_hei));% Peaks between
peakz_down = peakz_down0(Angz_filtered(localz_down0)<(Mean_z-threshold_Z_hei));% Peaks between

localpz_up=(localz_up-1)/desiredFs+T(1);
localpz_down=(localz_down-1)/desiredFs+T(1);
peakz_down= -peakz_down;

% find zero point
result1 = ((Mean_z-3) < Angz_filtered);
result2 = (Angz_filtered < (Mean_z+3));
result = result1 & result2;
equal_index = find(result == 1);

index0=[]; k=1;
temp=[]; j=1;
for i=1:length(equal_index)-1
    if equal_index(i)+1 == equal_index(i+1)
        j = j+1;
    end
    if equal_index(i)+1 ~= equal_index(i+1)
        temp = equal_index((i-j+1):i);
        if Angz_filtered(equal_index(i)) >= Angz_filtered(equal_index(i)+1)
            index0(k) = round(median(temp));
            k = k+1;
        end
        temp = [];j = 1;
    end
end

localpz_zero = T(index0);
peakz_zero = Angz_filtered(index0);

figure(2)
hold on
plot(T,Angz_filtered,'color','blue')
plot(localpz_up,peakz_up,'*','color','yellow')
plot(localpz_down,peakz_down,'*','color','green')
plot(localpz_zero,peakz_zero,'*','color','red')
legend('Original','Peak')
xlim([88 95])

%% split gait phases by feature points (ang Z)
local_z = [localpz_down;localpz_up;localpz_zero];
peak_z = [peakz_down;peakz_up;peakz_zero];

nz_down = repmat(1,length(localpz_down),1);
nz_up = repmat(2,length(localpz_up),1);
nz_zero = repmat(3,length(localpz_zero),1);
nz_phase = [nz_down;nz_up;nz_zero];

result_angz = [local_z,peak_z,nz_phase];
result_angz = sortrows(result_angz);

% fill in the form result matrix
form_result_angz = zeros(round(max(length(peakz_up),max(length(peakz_down),length(peakz_zero)))*1.2),3);
j = 1;
for i=2:length(result_angz)
    if form_result_angz(j,result_angz(i,3)) ~= 0 || result_angz(i-1,3) == 3
        j = j+1;
    end
    form_result_angz(j,result_angz(i,3)) = result_angz(i,1);
end

% delete row with more than 2 "0" records
ntemp=[]; j=1;
for i=1:length(form_result_angz)
    if median(form_result_angz(i,:)) == 0
        ntemp(j) = i; j = j+1;
    end
end
form_result_angz(ntemp',:) = [];

if n == 1
    left_angz = [form_result_angz,repmat(1,length(form_result_angz),1)];
end
if n == 2
    right_angz = [form_result_angz,repmat(2,length(form_result_angz),1)];
end

%% split gait phases by feature points (ang X)
local_x = [localpx_up;localpx_down;localpx_zero];
peak_x = [peakx_up;peakx_down;peakx_zero];

nx_up = repmat(1,length(localpx_up),1);
nx_down = repmat(2,length(localpx_down),1);
nx_zero = repmat(3,length(localpx_zero),1);
nx_phase = [nx_up;nx_down;nx_zero];

result_angx_original = [local_x,peak_x,nx_phase];
result_angx = sortrows(result_angx_original);

% fill in the form result matrix
form_result_angx = zeros(round(max(length(peakx_up),max(length(peakx_down),length(peakx_zero)))*1.2),3);
j = 1;
for i=2:length(result_angx)
    if form_result_angx(j,result_angx(i,3)) ~= 0 || result_angx(i-1,3) == 3
        j = j+1;
    end
    form_result_angx(j,result_angx(i,3)) = result_angx(i,1);
end

% delete row with more than two "0" records
ntemp=[]; j=1;
for i=1:length(form_result_angx)
    if median(form_result_angx(i,:)) == 0
        ntemp(j) = i; j = j+1;
    end
end
form_result_angx(ntemp',:) = [];

if n == 1
    left_angx = [form_result_angx,repmat(1,length(form_result_angx),1)];
end
if n == 2
    right_angx = [form_result_angx,repmat(2,length(form_result_angx),1)];
end

end

%% combine the left foot and the right foot
comb_angz_original = [left_angz;right_angz];
comb_angz = sortrows(comb_angz_original);

comb_angx = [left_angx;right_angx];
comb_angx = sortrows(comb_angx);


%% combine angX data verify angZ
full_angz = comb_angz;
for i=1:3
    check_locat = find(comb_angz(:,i)==0);
    check_angz = [comb_angz(check_locat,:),check_locat];
    for j=1:size(check_angz,1)
        [idx1, ~] = knnsearch(comb_angx(:,1),check_angz(j,1),'k',1);
        [idx2, ~] = knnsearch(comb_angx(:,2),check_angz(j,2),'k',1);
        [idx3, ~] = knnsearch(comb_angx(:,3),check_angz(j,3),'k',1);
        logic1 = abs(comb_angx(idx1,1) - check_angz(j,1))<=0.05;
        logic2 = abs(comb_angx(idx2,2) - check_angz(j,2))<=0.05;
        logic3 = abs(comb_angx(idx3,3) - check_angz(j,3))<=0.05;
        if (idx1==idx2 || idx2==idx3 || idx1==idx3) && (logic1 + logic2 +logic3 >= 2)
            full_angz(check_angz(j,5),i) = comb_angx(mode([idx1,idx2,idx3]),i);
        end
    end
end
full_angz = sortrows(full_angz);

%% statistical analysis of gait phase

% filter all records with "0"
stat_angz = full_angz;
ntemp=[]; j=1;
for i=1:length(stat_angz)
    if min(stat_angz(i,:)) == 0
        ntemp(j) = i; j = j+1;
    end
end
stat_angz(ntemp',:) = [];

% calculate period time of every gait phases
swing_time = stat_angz(:,2) - stat_angz(:,1);
loading_time = stat_angz(:,3) - stat_angz(:,2);
phase_time = [swing_time,loading_time];

foot_idx = stat_angz(:,4);
left_idx = find(foot_idx == 1);
right_idx = find(foot_idx == 2);

phase_left = phase_time(left_idx,:);
phase_right = phase_time(right_idx,:);

%csvwrite('/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed_by_matlab/phase_left.csv',phase_left);
%csvwrite('/Users/mofan/Documents/master_thesis/gait_analysis/4_data/processed_by_matlab/phase_right.csv',phase_right);

aaa = [mean(phase_left(:,1)),std(phase_left(:,1)),mean(phase_left(:,2)),std(phase_left(:,2))];
bbb = [mean(phase_right(:,1)),std(phase_right(:,1)),mean(phase_right(:,2)),std(phase_right(:,2))];
aaa = [aaa;bbb];
