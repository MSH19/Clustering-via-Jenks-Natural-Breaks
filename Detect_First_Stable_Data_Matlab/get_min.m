function [min_value, min_index] = get_min(my_array, array_len)
min_value = myArray(1);
min_index = 0;
% loop and update the min value and min index 
for k=1:array_len
    if (my_array(k) < min_value)
      min_value = my_array(k);
      min_index = k;
    end % end if 
end % end for
end % end function 
 