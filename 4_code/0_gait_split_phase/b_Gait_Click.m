clc
clear

data_gait_DIR = aa_Readfiles_ProProcess_gait();
data_click_DIR = bb_Readfiles_Click();
offsetTime = csvread('/Users/mofan/Documents/master_thesis/4_data/CSV_FILE_offsetTime/offset_time.csv',1,0);
result_click_gait = [];
dataset_click_phase = [];
errRate = []; index_err = 1;
cycle_time = zeros(46*3,3); index_phase = 1;

debug_sp = 3;
np = [0:26,28:45];
np_click = [0:7,9:11,13:16,20,21,23:25,28:29,31:33,35:36,38:44]+1;

ns = 20; %20
for i = np+1
    sp1 = 'uni_sp1';
    sp2 = 'uni_sp2';
    for j = 1:length(data_gait_DIR{i})
        % read gait data of person i

            i
            j
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
            
            % dealing with data that don't from standing (so walking)
            if strcmp(i_sp, 'sp1') || strcmp(i_sp, 'sp5')
            else
                [stat_angz, abs_stat_angz, phase_time, cycle_time_] = ba_Gait_Split_SwingorStance(DIR1, DIR2,...
                                                                        i_person, i_sp_num, debug_sp);
                % phase time saved
                cycle_time(index_phase,:) = [cycle_time_,str2num(i_person),i_sp_num];
                index_phase = index_phase+1;
                                                                    
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
                    idx_np = find(np_click == i,1);
                    if(BOO1 && BOO2 && isempty(idx_np) == 0)
                        click_DIR = data_click_DIR{k}{3};
                        [click_gait, data_click_phase_,...
                            err_all,err_key, percent] = bc_intac_Combining(stat_angz,...
                                                        offsetTime, click_DIR, i_person, i_sp_num);
                        
                                     
                        % save error rate
                        errRate_percent(index_err,:) = [str2num(i_person), i_sp_num, ...
                                        err_all, err_key, percent];
                        index_err = index_err+1;
                                                    
                        if debug_sp == i_sp_num % debug temp data
                            zdata_debug = stat_angz;
                            zdata_err_all = err_all;
                            zdata_err_key = err_key;
                        end                    
                        % save the result table
                        
                        dataset_click_phase = [dataset_click_phase; data_click_phase_];
                    end
                end
            end
        end
    end
end

FILE_DIR2 = '/Users/mofan/Documents/master_thesis/4_results/gait/dataset_click_phase.csv';
dlmwrite(FILE_DIR2, dataset_click_phase, 'precision', '%.4f');

FILE_DIR3 = '/Users/mofan/Documents/master_thesis/4_results/gait/error_rate_percent.csv';
dlmwrite(FILE_DIR3, errRate_percent, 'precision', '%.8f');

FILE_DIR4 = '/Users/mofan/Documents/master_thesis/4_results/gait/phase_time(ALL).csv';
dlmwrite(FILE_DIR4, cycle_time, 'precision', '%.4f');
