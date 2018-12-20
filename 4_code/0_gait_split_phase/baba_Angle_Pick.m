function [data_pick] = baba_Angle_Pick(data)
    AVG = 1;
    for i = 1:length(data)
        x = data(i);
        if AVG >= 0
            if(x < -(180-AVG-15))
                x = 360 + x;
            end
        end

        if AVG < 0
            if(x > 180+AVG-15)
                x = x - 360;
            end
        end
        data(i) = x;
    end
    data_pick = data;
end