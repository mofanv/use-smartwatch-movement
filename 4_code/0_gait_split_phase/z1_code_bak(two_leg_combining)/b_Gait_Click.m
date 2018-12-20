clc
clear

data_gait_DIR = aa_Readfiles_ProProcess_gait();
data_click_DIR = bb_Readfiles_Click();
offsetTime = csvread('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_offsetTime/offset_time.csv',1,0);
result_click_gait = [];
dataset_click_phase = [];
errRate = []; index_err = 1;

np = 14;
%np = [0,1,2,3,5,6,7,9,10,11,12,14,15,16,20,21];
ns = 20; %20
for i = np+1
    sp1 = 'uni_sp1';
    sp2 = 'uni_sp2';
    for j = 1:ns
        % read gait data of person i
        if strcmp(data_gait_DIR{i}{j}(3), 'left_leg')
            DIR1 = char(data_gait_DIR{i}{j}(4));
            sp1 = char(data_gait_DIR{i}{j}(2));
        end
        if strcmp(data_gait_DIR{i}{j}(3), 'right_leg')
            DIR2 = char(data_gait_DIR{i}{j}(4));
            sp2 = char(data_gait_DIR{i}{j}(2));
        end
        
        % sp from left leg = sp from right leg
        if strcmp(sp1,sp2)
            i_person = char(data_gait_DIR{i}{j}(1));
            i_sp = sp1;
            i_sp_num = regexp(i_sp,'sp','split'); i_sp_num = str2num(i_sp_num{2});
            sp1 = 'uni_sp1';
            sp2 = 'uni_sp2';
            
            % dealing with data that don't from standing (so walking and running)
            if strcmp(i_sp, 'sp1') || strcmp(i_sp, 'sp5')
            else
                [comb_angz, stat_angz, phase_time] = ba_Gait_Split_SwingorStance(DIR1, DIR2, i_sp_num);
                
                % read click data of person i
                for(k = 1:length(data_click_DIR))
                    % whether person(gait) == person(interaction)
                    tempPE = regexp(char(data_click_DIR{k}{1}),'No','split');
                    tempPE = str2num(tempPE{2});
                    BOO1 = tempPE == str2num(i_person);

                    % whether speed(gait) == speed(interaction)
                    tempSP = char(data_click_DIR{k}{2});
                    BOO2 = strcmpi(tempSP,i_sp);

                    % read corresponding phase data
                    if(BOO1 && BOO2)
                        click_DIR = data_click_DIR{k}{3};
                        [click_gait, data_click_phase, ...
                            errRate_leg_key, errRate_leg_all] = bc_intac_Combining(stat_angz, offsetTime, click_DIR, i_person);
                        
                        % save error rate
                        errRate(index_err,:) = [str2num(i_person), i_sp_num, ...
                                        errRate_leg_all, errRate_leg_key];
                        index_err = index_err+1;
                        
                        % build the table of click and gait
                        stat_click_gait = tabulate(click_gait);
                        indexReal = find((stat_click_gait(:,1) == 11)|(stat_click_gait(:,1) == 12)|...
                            (stat_click_gait(:,1) == 21)|(stat_click_gait(:,1) == 22));
                        stat_click_gait = stat_click_gait(indexReal,:);
                        stat_click_gait(:,4) = tempPE;
                        str_SP = regexp(tempSP,'Sp','split');
                        stat_click_gait(:,5) = str2num(str_SP{2});
                        
                        isp = repmat(str2num(str_SP{2}),size(data_click_phase,1),1);
                        data_click_phase_ = [data_click_phase, isp];
                        dataset_click_phase = [dataset_click_phase; data_click_phase_];
                        
                        % mark the absolute phase time
                        indexAT = find(stat_click_gait(:,1) == 11,1);
                        if length(indexAT) == 1    stat_click_gait(indexAT,6) = phase_time(1,1);
                        end
                        indexAT = find(stat_click_gait(:,1) == 12,1);
                        if length(indexAT) == 1    stat_click_gait(indexAT,6) = phase_time(1,3);
                        end
                        indexAT = find(stat_click_gait(:,1) == 21,1);
                        if length(indexAT) == 1    stat_click_gait(indexAT,6) = phase_time(2,1);
                        end
                        indexAT = find(stat_click_gait(:,1) == 22,1);
                        if length(indexAT) == 1    stat_click_gait(indexAT,6) = phase_time(2,3);
                        end
                        indexAT = find(stat_click_gait(:,1) == 0,1);
                        if length(indexAT) == 1    stat_click_gait(indexAT,6) = 0;
                        end
                        
                        if strcmp(i_sp,'sp3')
                            temp(:,1:3) = stat_angz(:,1:3) - stat_angz(1,1);
                            temp(:,4) = stat_angz(:,4);
                        end
                        
                        % save the result table
                        i_person
                        i_sp
                        result_click_gait = [result_click_gait; stat_click_gait];
                        
                        
                    end
                end
            end
        end
    end
end



%FILE_DIR1 = '/Users/mofan/Documents/master_thesis/4_results/gait/click_gait(per_phase).csv';
%dlmwrite(FILE_DIR1, result_click_gait, 'precision', '%.4f');

%FILE_DIR2 = '/Users/mofan/Documents/master_thesis/4_results/gait/dataset_click_phase.csv';
%dlmwrite(FILE_DIR2, dataset_click_phase, 'precision', '%.4f');

%FILE_DIR3 = '/Users/mofan/Documents/master_thesis/4_results/gait/recognize_error_rate.csv';
%dlmwrite(FILE_DIR3, errRate, 'precision', '%.8f');

