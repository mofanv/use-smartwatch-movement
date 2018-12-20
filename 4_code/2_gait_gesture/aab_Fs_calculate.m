function [fc] = aab_Fs_calculate(i, j, cycle_time)

% sp = 1 or 5
if j == 1
    fc = 5;
elseif j == 5
    j = 4;
end

% sp = 2, 3, 4   
if j==2 || j==3 || j==4
    index = find((cycle_time(:,2) == i) & (cycle_time(:,3) == j));
    ct = cycle_time(index,1);
    fc = 1/ct;
end
    
end