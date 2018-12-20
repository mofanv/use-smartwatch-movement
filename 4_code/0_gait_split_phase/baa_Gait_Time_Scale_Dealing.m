function [data] = baa_Gait_Time_Scale_Dealing(DIR)
%% Time Scale Compared
%DIR = '/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_324/p00/sp1_B0B4486E4145_2018-03-18_19-41-09.csv';
data = importdata(DIR);

% YEAR-MONTH-DAY string
temp = regexp(DIR,'_','split');
temp = char(temp(length(temp) - 1));
YMD = regexp(temp,'-','split');
YMD = str2num(char(YMD));

%HH:MM:SS:FFF string
dateFFF = data.textdata(2); dateFFF=char(dateFFF);
HMS = regexp(dateFFF,':','split');
HMS = str2num(char(HMS));

% Relative timestamp to Absolute timestamp
dateT = datetime(YMD(1),YMD(2),YMD(3),HMS(1),HMS(2),HMS(3),HMS(4));
dateT = posixtime(dateT);
data.data(:,1) = data.data(:,1) + dateT;
end