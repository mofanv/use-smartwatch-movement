clc
clear
data_gait = aa_Readfiles_ProProcess_gait();
data_intacPhase = ab_Readfiles_ProProcess_intac();
offsetTimeS = csvread('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_offsetTime/offset_time.csv',1,0);
offsetTime = csvread('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_offsetTime/offset_time(new_with_phonetime).csv',0,0);
exact_period = dlmread('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/4_wrist/0wrist_range_done.csv');

%np = [0:11,13:16,20,21]; % original analysis
np = [0:1,3:13,15:21,23:25,28:29,31:33,35:36,38:44]; % delete error 2, 14, 22 ,30, 34, 37, 45, 46
ns = 1:20; % 20

 splitpoint = zeros(length(np)*length(ns), 10);
splitpoint = [];

for i = np+1
    for j = 1:length(data_gait{i})
        % read gait data of person i
        dat_person = importdata(strcat(char(data_gait{i}{j}(4))));
        i_person = char(data_gait{i}{j}(1));
        i_sp = char(data_gait{i}{j}(2));
        i_sp_num = regexp(i_sp,'sp','split'); i_sp_num = str2num(i_sp_num{2});
        i_person
        i_sp
        
        % find the split time for Interaction Phase data
        for(k = 1:length(data_intacPhase))
            
            % whether person(gait) == person(interaction)
            tempPE = regexp(char(data_intacPhase{k}{1}),'No','split');
            tempPE = str2num(tempPE{2});
            BOO1 = tempPE == str2num(i_person);
            
            % whether speed(gait) == speed(interaction)
            if(strcmp(char(data_intacPhase{k}{2}),'Sp0'))
                tempSP = 'Sp1';
            else
                tempSP = char(data_intacPhase{k}{2});
            end
            BOO2 = strcmpi(tempSP,i_sp);
            
            % read corresponding phase data
            if(BOO1 && BOO2)
                dat_intac = importdata(data_intacPhase{k}{3});

                %% date transfrom
                % YEAR-MONTH-DAY string
                temp = regexp(char(data_gait{i}{j}(4)),'_','split');
                dateDAY = char(temp(length(temp) - 1));
                YMD = regexp(dateDAY,'-','split');
                YMD = str2num(char(YMD));
                %HH:MM:SS:FFF string
                dateFFF = dat_person.textdata{2,1};
                HMS = regexp(dateFFF,':','split');
                HMS = str2num(char(HMS));

                % Relative timestamp to Absolute timestamp
                t_date = datetime(YMD(1),YMD(2),YMD(3),HMS(1),HMS(2),HMS(3),HMS(4));
                t = posixtime(t_date);
                dat_person.data(:,1) = dat_person.data(:,1) + t;
                gait_time = dat_person.data(:,1);
                
                %% Split point (each task)
                % 1look   com time = phone time - ((watch-com)+(phone-watch))
                index1 = find(gait_time > (dat_intac.data(2)/1000 - offsetTime(i,3) - (- offsetTimeS(i,5))), 1);
                index2 = find(gait_time > (dat_intac.data(3)/1000 - offsetTime(i,3) - (- offsetTimeS(i,5))), 1);
                index3 = find(gait_time > (dat_intac.data(4)/1000 - offsetTime(i,3) - (- offsetTimeS(i,5))), 1);
                % 4swipe_touch_look_light
                index4 = find(gait_time > (dat_intac.data(5)/1000 - offsetTime(i,3) - (- offsetTimeS(i,5))), 1);
                % 5voice
                index5 = find(gait_time > (dat_intac.data(6)/1000 - offsetTime(i,3) - (- offsetTimeS(i,5))), 1);
                % 6find_title
                index6 = find(gait_time > (dat_intac.data(7)/1000 - offsetTime(i,3) - (- offsetTimeS(i,5))), 1);
                idx_temp = (exact_period(:,2) == str2num(i_person)) & (exact_period(:,3) == i_sp_num);
                start_time = exact_period(idx_temp,4);
                end_time = exact_period(idx_temp,5);
                index7 = find(gait_time > gait_time(1)+start_time/1000, 1);
                index8 = find(gait_time > gait_time(1)+end_time/1000, 1);
                
                num_SP = regexp(tempSP,'Sp','split');
                splitpoint_ = [i-1,str2num(num_SP{2}),j,0,index1,index2,index3,index4,index5,index6,index7,index8];
                %if (length(splitpoint_) ~= 12) splitpoint_ = [i-1,str2num(num_SP{2}),j,0,0,0,0,0,0,0,0,0];
                %end
                splitpoint = [splitpoint;splitpoint_];
                
                %% Split data and save
                dat_split1 = dat_person.data(1:(index4),:);
                FILE_DIR_sp1 = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/1_look/p',...
                                    i_person,'_',i_sp,'_',char(data_gait{i}{j}(3)),'.csv');
                dlmwrite(FILE_DIR_sp1, dat_split1, 'precision', '%.5f');
                dat_split2 = dat_person.data((index4):(index5),:);
                FILE_DIR_sp2 = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/2_touch/p',...
                                    i_person,'_',i_sp,'_',char(data_gait{i}{j}(3)),'.csv');
                dlmwrite(FILE_DIR_sp2, dat_split2, 'precision', '%.5f');
                dat_split3 = dat_person.data((index5):(index6),:);
                FILE_DIR_sp3 = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/3_voice/p',...
                                    i_person,'_',i_sp,'_',char(data_gait{i}{j}(3)),'.csv');
                dlmwrite(FILE_DIR_sp3, dat_split3, 'precision', '%.5f');
                dat_split4 = dat_person.data(index7:index8,:);
                FILE_DIR_sp4 = strcat('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_split/4_wrist/p',...
                                    i_person,'_',i_sp,'_',char(data_gait{i}{j}(3)),'.csv');
                dlmwrite(FILE_DIR_sp4, dat_split4, 'precision', '%.5f');
            end
        end
    end
end

FILE_DIR = '/Users/mofan/Documents/master_thesis/4_results/gait_gesture/splitpoint_filter.csv';
dlmwrite(FILE_DIR, splitpoint);
