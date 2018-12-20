clc
clear

control_num = 12;
timeD= [];

for iperson =1:23

if(iperson==1) DIR = 'p0_sp1_B0B448BAEC7E_2018-03-18_19-41-09.csv'; NO = 'No000'; height=0.004; dis = 2.5; %IO_up down up
end
if(iperson==2) DIR = 'p1_sp1_B0B448BAEC7E_2018-03-21_14-43-04.csv'; NO = 'No001'; height=0.004; dis = 2.5; %IO_up down up
end
if(iperson==3) DIR = 'p2_sp1_B0B448BAEC7E_2018-03-21_15-01-42.csv'; NO = 'No002'; height=0.002; dis = 2.9; %IO_up down up
end
if(iperson==4) DIR = 'p3_sp1_B0B448BAEC7E_2018-03-21_16-48-57.csv'; NO = 'No003'; height=0.004; dis = 2.2; %IO_up down up
end
if(iperson==5) DIR = 'p4_sp1_B0B448BAEC7E_2018-03-22_10-03-48.csv'; NO = 'No004'; height=0.005; dis = 2; %IO_up down up
end
if(iperson==6) DIR = 'p5_sp1_B0B448BAEC7E_2018-03-22_15-19-01.csv'; NO = 'No005'; height=0.004; dis = 2.5; %IO_up down up
end
if(iperson==7) DIR = 'p6_sp1_B0B448BAEC7E_2018-03-22_16-23-08.csv'; NO = 'No006'; height=0.0005; dis = 3.2; %IO_up down up
end
if(iperson==8) DIR = 'p7_sp1_B0B448BAEC7E_2018-03-22_19-18-01.csv'; NO = 'No007'; height=0.004; dis = 2; %IO_up down up
end
if(iperson==9) DIR = 'p8_sp1_B0B448BAEC7E_2018-03-22_20-15-20.csv'; NO = 'No008';  height=0.005; dis = 3; %IO_up down up
end
if(iperson==10) DIR = 'p9_sp1_B0B448BAEC7E_2018-03-23_09-17-57.csv'; NO = 'No009'; height=0.005; dis = 3.5; %IO_up down up
end
if(iperson==11) DIR = 'p10_sp1_B0B448BAEC7E_2018-03-23_10-49-08.csv'; NO = 'No010'; height=0; dis = 3; %IO_up down up
end
if(iperson==12) DIR = 'p11_sp1_B0B448BAEC7E_2018-03-23_13-33-17.csv'; NO = 'No011'; height=0.003; dis = 4; %IO_up down up
end
if(iperson==13) DIR = 'p13_sp1_B0B448BAEC7E_2018-03-23_16-04-30.csv'; NO = 'No013'; height=0.004; dis = 1.7; %IO_up down up
end
if(iperson==14) DIR = 'p14_sp1_B0B448BAEC7E_2018-03-23_17-05-34.csv'; NO = 'No014'; height=0; dis = 2.5; %IO_up down up
end
if(iperson==15) DIR = 'p15_sp1_B0B448BAEC7E_2018-03-23_19-38-53.csv'; NO = 'No015'; height=0.003; dis = 2.5; %IO_up down up
end
if(iperson==16) DIR = 'p16_sp1_B0B448BAEC7E_2018-03-23_19-53-47.csv'; NO = 'No016'; height=0; dis = 4; %IO_up down up
end
if(iperson==17) DIR = 'p20_sp1_B0B448BAEC7E_2018-03-24_14-11-03.csv'; NO = 'No020'; height=0.005; dis = 2.5; %IO_up down up
end
if(iperson==18) DIR = 'p21_sp1_B0B448BAEC7E_2018-03-24_15-03-47.csv'; NO = 'No021';  height=0.003; dis = 4; %IO_up down up
end

if 1 <= iperson & iperson <= 18
    WD = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_offsetTime/';
    DIR = strcat(WD,DIR);
    WD_intac = '/Users/mofan/Documents/master_thesis/4_data/aaa_data_324/click/';
    DIR_intac = strcat(WD_intac,NO,'_Sp0_click.txt');
end

%% bad part click
if(iperson==19) DIR = 'p12_sp1_B0B448BAEC7E_2018-03-23_14-52-34.csv'; NO = 'No012';  height=0; dis = 5; %IO_up down up
end
if(iperson==20) DIR = 'p17_sp1_B0B448BAEC7E_2018-03-24_09-54-36.csv'; NO = 'No017';  height=0.003; dis = 3; %IO_up down up
end
if(iperson==21) DIR = 'p18_sp1_B0B448BAEC7E_2018-03-24_10-34-27.csv'; NO = 'No018';  height=0; dis = 5; %IO_up down up
end
if(iperson==22) DIR = 'p19_sp1_B0B448BAEC7E_2018-03-24_13-27-55.csv'; NO = 'No019';  height=0.003; dis = 4; %IO_up down up
end
if(iperson==23) DIR = 'p22_sp1_B0B448BAEC7E_2018-03-24_15-46-42.csv'; NO = 'No022';  height=0; dis = 5; %IO_up down up
end

if 19 <= iperson && iperson <= 23
    WD = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_offsetTime/bad_click/';
    DIR = strcat(WD,DIR);
    WD_intac = '/Users/mofan/Documents/master_thesis/4_data/aaa_data_324/click_error people/';
    DIR_intac = strcat(WD_intac,NO,'_Sp0_click.txt');
end

%%

data=importdata(DIR);
A=data(1).data;

t=A(:,1);
acc_x=A(:,2);
acc_y=A(:,3);
acc_z=A(:,4);
acc_xyz = (acc_x.^2 + acc_y.^2 + acc_z.^2).^(1/2);

frequency=[];
desiredFs=1000;% transfrom frequency to 1000 Hz 
[Acc_xyz, T] = resample(acc_xyz,t,desiredFs);
dt_accxyz = detrend(Acc_xyz); %remove trends from data

fc = 5; %cut off frequency
fs = desiredFs; %sampling rate
[b,a] = butter(5,fc/(fs/2));
Accx_filtered = filter(b,a,dt_accxyz); %filter frequency

[peakxyz_up,localxyz_up] = findpeaks(Accx_filtered,'minpeakheight',height, 'minpeakdistance',desiredFs/dis);
if iperson == 19 || iperson == 21 || iperson == 23
    [peakxyz_up,localxyz_up] = findpeaks(Accx_filtered, 'minpeakdistance',desiredFs/dis);
end

timexyz_up = T(localxyz_up);

%hold on
%figure(1)
%plot(T,Accx_filtered,'color','blue')
%plot(timexyz_up,peakxyz_up,'*','color','red')
%xlim([timexyz_up(1)-2 timexyz_up(1)+10])
%ylim([-0.5 0.5])

%%
data_=importdata(DIR_intac);
time_watch = data_.data(:,9);
time_phone = data_.data(:,10);

% YEAR-MONTH-DAY string
temp = regexp(DIR,'_','split');
temp = char(temp(length(temp) - 1));
YMD = regexp(temp,'-','split');
YMD = str2num(char(YMD));
%HH:MM:SS:FFF string
dateFFF = data.textdata(1); dateFFF=char(dateFFF);
HMS = regexp(dateFFF,':','split');
HMS = str2num(char(HMS));

% Relative timestamp to Absolute timestamp
dateT = datetime(YMD(1),YMD(2),YMD(3),HMS(1),HMS(2),HMS(3),HMS(4));
dateT = posixtime(dateT);
touchtime = timexyz_up-timexyz_up(1) + dateT;

timeDIFF = time_watch(1:control_num)/1000 - touchtime(1:control_num); % up is more normal
length_min = min(length(touchtime),length(time_watch));
timeDIFF_100 = time_watch(1:length_min)/1000 - touchtime(1:length_min); % up is more normal

%hold on
%figure(2)
%plot(1:control_num,(timeDIFF - timeDIFF(1)),'color','blue')

%hold on
%figure(3)
%plot(1:length_min,(timeDIFF_100 - timeDIFF_100(1)),'color','blue')

wa_co = mean(timeDIFF);
%wa_co
%std(timeDIFF)
NO_ = regexp(NO,'No','split'); NO_ = str2num(char(NO_{2}));
iperson
ph_wa = (data_.data(1:control_num,10) - data_.data(1:control_num,9))/1000;
timeD_ = [wa_co,std(timeDIFF),mean(ph_wa),NO_];
timeD = [timeD;timeD_];
end

timeD = sortrows(timeD,4);
FILE_DIR = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_offsetTime/offset_time(new_with_phonetime).csv';
dlmwrite(FILE_DIR, timeD, 'precision', '%.10f');


