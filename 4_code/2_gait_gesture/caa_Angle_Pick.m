function [data_pick] = caa_Angle_Pick(data, mean_z)
    AVG = mean_z;
    for i = 1:length(data)
        x = data(i);
        if(x < AVG - 20)
            x = 360 + x;
        end
        data(i) = x;
    end
    data_pick = data;
end