function [data_Resample,local_min2,local_max1,local_min1] = cc_find_key_point_z(data_Resample,ip,js)

Fs = 1000;
desiredFs = Fs;

T = data_Resample(:,1);
Angz_filtered = data_Resample(:,2);
Angx_filtered = data_Resample(:,3);
len = length(Angz_filtered);

%%
[peekz1, localz1] = findpeaks(Angz_filtered,'MinPeakDistance',desiredFs);
[peekz2, localz2] = findpeaks(-Angz_filtered,'MinPeakDistance',desiredFs);
peekz2 = -peekz2;

%% find zero point
Mean_z = 200;
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

indexMIN1=[]; indexMIN2=[]; indexMAX1=[];

%% 1(1) find minimum point next to 'indexD'
k = 1;
for i = indexD
   swit = 1;
   for j = 1:1000
       if (swit == 1) && (i+j <= len) && (Angz_filtered(i+j) >= Angz_filtered(i+j-1))
           indexMIN1(k) = i+j-1;
           k = k + 1;
           swit = 0;
       end
   end
end
local_min1 = T(indexMIN1);
peak_min1 = Angz_filtered(indexMIN1);

%% 1(2) find minimum point next to 'indexU'
k = 1;
for i = indexU
   swit = 1;
   for j = 1:1000
       if (swit == 1) && (i-j-1 > 0) && (Angz_filtered(i-j) <= Angz_filtered(i-j-1))
           indexMIN2(k) = i-j-1;
           k = k + 1;
           swit = 0;
       end
   end
end
local_min2 = T(indexMIN2);
peak_min2 = Angz_filtered(indexMIN2);

%% 2(1) find maximum point next to 'indexU'
k = 1;
for i = indexU
   swit = 1;
   for j = 1:1000
       if (swit == 1) && (i+j <= len) && (Angz_filtered(i+j) <= Angz_filtered(i+j-1))
           indexMAX1(k) = i+j-1;
           k = k + 1;
           swit = 0;
       end
   end
end
local_max1 = T(indexMAX1);
peak_max1 = Angz_filtered(indexMAX1);

%% plot and check
%figure(ip*5+js)
%hold on
%plot(T, Angz_filtered,'black')
%plot(T, Angx_filtered,'red')

%plot(localpz_zeroD,peakz_zeroD,'*','color','red')
%plot(localpz_zeroU,peakz_zeroU,'*','color','red')
%plot(local_min1,peak_min1,'o','color','green')
%plot(local_min2,peak_min2,'o','color','green')
%plot(local_max1,peak_max1,'o','color','green')


%for i = local_min2      plot([i,i],[-200,300]) % 1
%end
%for i = local_max1      plot([i,i],[-200,300]) % 2
%end
%for i = local_min1      plot([i,i],[-200,300]) % 3
%end
end