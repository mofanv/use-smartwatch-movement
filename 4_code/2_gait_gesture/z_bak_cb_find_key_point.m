function [localpz_zeroD,peakz_zeroD,data_Resample] = cb_find_key_point(data_Resample,ip,js,thr_inter_add)

Fs = 1000;
desiredFs = Fs;
threshold = 2;

T = data_Resample(:,1);
Angz_filtered = data_Resample(:,2);
len = length(Angz_filtered);

%% find zero point
Mean_z = thr_inter_add;
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

indexMAX1=[]; indexMAX2=[]; indexMAX3=[];
indexMIN1=[]; indexMIN2=[]; indexMIN3=[];

%% 1(1) find maximum point next to 'indexU'
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

%% 1(2) local minimum point next to 'max'
k = 1;
for i = indexMAX1
   swit = 1;
   for j = 1:1000
       if (swit == 1) && (i+j <= len) && (Angz_filtered(i+j) >= Angz_filtered(i+j-1))
           indexMAX2(k) = i+j-1;
           k = k + 1;
           swit = 0;
       end
   end
end
local_max2 = T(indexMAX2);
peak_max2 = Angz_filtered(indexMAX2);

%% 1(3) local maximum point next to 'min'
k = 1;
for i = indexMAX2
   swit = 1;
   for j = 1:1000
       if (swit == 1) && (i+j <= len) && (Angz_filtered(i+j) <= Angz_filtered(i+j-1))
           indexMAX3(k) = i+j-1;
           k = k + 1;
           swit = 0;
       end
   end
end
local_max3 = T(indexMAX3);
peak_max3 = Angz_filtered(indexMAX3);


%% 2(1) find minimum point next to 'indexD'
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

%% 2(2) find minimum point between 'indexD' 'indexU'
k = 1;
for i = indexMIN1
   swit = 1;
   for j = 1:1000
       if (swit == 1) && (i+j <= len) && (Angz_filtered(i+j) <= Angz_filtered(i+j-1))
           indexMIN2(k) = i+j-1;
           k = k + 1;
           swit = 0;
       end
   end
end
local_min2 = T(indexMIN2);
peak_min2 = Angz_filtered(indexMIN2);

%% 2(3) find minimum point next to 'indexU'
k = 1;
for i = indexU
   swit = 1;
   for j = 1:1000
       if (swit == 1) && (i-j-1 > 0) && (Angz_filtered(i-j) <= Angz_filtered(i-j-1))
           indexMIN3(k) = i-j-1;
           k = k + 1;
           swit = 0;
       end
   end
end
local_min3 = T(indexMIN3);
peak_min3 = Angz_filtered(indexMIN3);

%% plot and check
figure(ip*5+js)
hold on
plot(T, Angz_filtered,'black')
plot(T, data_Resample(:,3),'red')

%plot(localpz_zeroD,peakz_zeroD,'*','color','blue')
%plot(localpz_zeroU,peakz_zeroU,'*','color','green')
%if ~isempty(peak_max1)  plot(local_max1,peak_max1,'o','color','red')
%end
%if ~isempty(peak_max2)  plot(local_max2,peak_max2,'o','color','yellow')
%end
%if ~isempty(peak_max3)  plot(local_max3,peak_max3,'o','color','magenta')
%end
%if ~isempty(peak_min1)  plot(local_min1,peak_min1,'+','color','red')
%end
%if ~isempty(peak_min2)  plot(local_min2,peak_min2,'+','color','yellow')
%end
%if ~isempty(peak_min3)  plot(local_min3,peak_min3,'+','color','magenta')
%end
end