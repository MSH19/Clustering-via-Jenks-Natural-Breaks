function [avg, mae] = get_MAE(my_array, array_len)

% get the average of the array
array_sum = 0;
for i=1:array_len
    array_sum = array_sum + my_array(i);
end % end for 
avg = array_sum / array_len;

% get the sum of absolute deviations from the array's mean
sum_dev = 0; 
for i=1:array_len
    dev = my_array(i) - avg;
    if (dev < 0) 
        dev = dev * (-1);
    end % end if  
    sum_dev = sum_dev + dev;
end % end for 

% calculate the Mean Absolute Error (MAE) 
mae = sum_dev / array_len;

end % end function