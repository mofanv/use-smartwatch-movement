function [data_pick] = baa_Angle_Pick(data, mean_z)
    AVG = mean_z;
    for i = 1:length(data)
        x = data(i);
        if AVG >= 0
            if(x < -(180-AVG-120))
                x = 360 + x;
            end
        end

        if AVG < 0
            if(x > 180+AVG-120)
                x = x - 360;
            end
        end
        data(i) = x;
    end
    data_pick = data;
end