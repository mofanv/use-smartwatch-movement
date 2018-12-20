function [localpz_up,peakz_up,localpz_down,peakz_down,...
    localpz_zeroD,peakz_zeroD,localpz_zeroU,peakz_zeroU] = bac_Gait_KeyPoint_Finding(data, Fs, i_sp_num)
%% Key Point Finding
%data = data_Resample;
desiredFs = Fs;

T = data(:,1);
%Accx_filtered = data(:,2);
%Accy_filtered = data(:,3);
%Accz_filtered = data(:,4);
%Angx_filtered = data(:,5);
%Angy_filtered = data(:,6);
Angz_filtered = data(:,7);


if abs(min(Angz_filtered(1:1000)) - max(Angz_filtered(1:1000))) <= 5
    Mean_z = mean(Angz_filtered(1:1000));
else
    Mean_z = 0;
end

Height = 10;

if i_sp_num == 2    Width = desiredFs*1;
end
if i_sp_num == 3    Width = desiredFs*0.7;
end
if i_sp_num == 4    Width = desiredFs*0.5;
end


%%  z coordination data processing (find peak)
% find peak
[peakz_up0,localz_up0] = findpeaks(Angz_filtered,'minpeakdistance',Width);    %,'minpeakheight',0.05
localz_up = localz_up0(Angz_filtered(localz_up0)>(Mean_z+Height));% Peaks between 
peakz_up = peakz_up0(Angz_filtered(localz_up0)>(Mean_z+Height));% Peaks between 
[peakz_down0,localz_down0] = findpeaks(-Angz_filtered,'minpeakdistance',Width);  %,'minpeakheight',0.05
localz_down = localz_down0(Angz_filtered(localz_down0)<(Mean_z-Height));% Peaks between 
peakz_down = peakz_down0(Angz_filtered(localz_down0)<(Mean_z-Height));% Peaks between 

localpz_up=(localz_up-1)/desiredFs+T(1);
localpz_down=(localz_down-1)/desiredFs+T(1);
peakz_down= -peakz_down;

% find zero point
result1 = ((Mean_z-3) < Angz_filtered);
result2 = (Angz_filtered < (Mean_z+3));
result = result1 & result2;
equal_index = find(result == 1);

indexD=[]; kd=1;
indexU=[]; ku=1;
temp=[]; j=1;
for i=1:length(equal_index)-1
    if equal_index(i)+1 == equal_index(i+1) % continuous or not
        j = j+1;
    end
    if equal_index(i)+1 ~= equal_index(i+1)
        temp = equal_index((i-j+1):i);
        if Angz_filtered(equal_index(i)) >= Angz_filtered(equal_index(i)+1) % direction down
            indexD(kd) = round(median(temp));
            kd = kd+1;
        end
        if Angz_filtered(equal_index(i)) < Angz_filtered(equal_index(i)+1) % direction up
            indexU(ku) = round(median(temp));
            ku = ku+1;
        end
        temp = [];j = 1;
    end
end

localpz_zeroD = T(indexD);
peakz_zeroD = Angz_filtered(indexD);

localpz_zeroU = T(indexU);
peakz_zeroU = Angz_filtered(indexU);

%figure(i_sp_num)
%hold on
%plot(T,Angz_filtered,'color','blue')
%plot(localpz_up,peakz_up,'*','color','yellow')
%plot(localpz_down,peakz_down,'*','color','green')
%plot(localpz_zero,peakz_zero,'*','color','red')
%legend('Original','Peak')
%xlim([1521748975.32900 1521748986.11600])
end