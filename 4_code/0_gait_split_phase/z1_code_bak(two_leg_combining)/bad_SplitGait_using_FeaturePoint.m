function [phase_angz] = bad_SplitGait_using_FeaturePoint(n,i_sp_num,data_Resample,...
                                                           localpz_up,peakz_up,localpz_down,peakz_down,...
                                                           localpz_zeroD,peakz_zeroD,localpz_zeroU,peakz_zeroU)

%n=2;
% use zero1 or zero2 (the zero point)
local_temp = [localpz_up; localpz_down];
peak_temp = [peakz_up; peakz_down];
nz_upT = repmat(1,length(localpz_up),1);
nz_downT = repmat(2,length(localpz_down),1);
phase_temp = [nz_upT; nz_downT];

result_temp = [local_temp,peak_temp,phase_temp];
result_temp = sortrows(result_temp);

% the difference value between up and down
diff_temp = [];
for i = 2:size(result_temp,1)
    if (result_temp(i,3) == 2) && (result_temp(i-1,3) == 1) % down - up
        diff_ = result_temp(i,1) - result_temp(i-1,1); 
        diff_temp = [diff_temp, diff_];
    end
end
sum_diff = sum(diff_temp);
alltime = result_temp(size(result_temp,1),1) - result_temp(1,1);
rate_diff = sum_diff/alltime;

if rate_diff > 0.5
    localpz_zero = localpz_zeroU; peakz_zero = peakz_zeroU;
    result_temp(:,3) = 3 - result_temp(:,3); % 2 to 1; 1 to 2
    result_temp(:,2) = - result_temp(:,2);
    data_Resample(:,7) = - data_Resample(:,7);
else
    localpz_zero = localpz_zeroD; peakz_zero = peakz_zeroD;
end

% combine all (down up zero)
nz_zero = repmat(3,length(localpz_zero),1);
zeroALL = [localpz_zero,peakz_zero,nz_zero];

result_angz = [result_temp;zeroALL];
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
    phase_angz = [form_result_angz,repmat(1,length(form_result_angz),1)];
end
if n == 2
    phase_angz = [form_result_angz,repmat(2,length(form_result_angz),1)];
end



%% plot
%if i_sp_num == 2
    index_1 = find(result_temp(:,3) == 1);
    index_2 = find(result_temp(:,3) == 2);
    figure(i_sp_num)
    hold on
    plot(data_Resample(:,1),data_Resample(:,7),'color','blue')
    plot(result_temp(index_1,1),result_temp(index_1,2),'*','color','yellow')
    plot(result_temp(index_2,1),result_temp(index_2,2),'*','color','green')
    plot(localpz_zero,peakz_zero,'*','color','red')
    legend('Original','Peak')
    xlim([data_Resample(100000,1) data_Resample(105000,1)])
    ylim([-100 100])
%end
end