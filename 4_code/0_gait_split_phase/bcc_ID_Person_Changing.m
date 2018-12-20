function [output_ID] = bcc_ID_Person_Changing(input_ID, key)
%key = 'want_given';
%input_ID = '0';
    real_ID = [0:11,13:16,20,21];
    given_ID = 1:18;
    
    if  ischar(input_ID)
        input_ID = str2double(input_ID);
    end
    
    if strcmp(key,'want_real')
        index = find(given_ID==input_ID,1);
        output_ID = real_ID(index);
    end

    if strcmp(key,'want_given')
        index = find(real_ID==input_ID,1);
        output_ID = given_ID(index);
    end
end