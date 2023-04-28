% This code aims to detect the first set of stable values received
% It uses a stored array of values, however, the same method could be
% easily applied to streaming data (sensors)
% If none of the values were found to match the error condition, the code
% selects the average of the array that showed the minimum absolute error 
clc;
close all;
clear all;

% assume that the sensor values are stored in an array (total of 20 values)
% sensor_array = [150 130 110 90 70 65 60 55 50 50 40 42 41 42 41 42 41 40 40 42];
sensor_array = [150 120 150 120 150 120 150 60 65 60 65 60 65 150 120 150 120 150 120 150];
total_size = 20;

% define a sliding window to store evaluate sub-sequences while new measurements 
% are received ( or read from the array) 
temporal_size = 5;
temporal_array = zeros (1, temporal_size);

% define an array to store the scores (MAE errors)
% in this case the size of the scores array is 16 
scores_size = total_size - (temporal_size - 1);
scores_array = zeros (1, scores_size);
scores_counter = 1;
% array to store the candidate values (averages of all sub-sequences)  
candidates = zeros (1, scores_size);

% define variables to hold the result and the result error 
result_value = 0;
result_MAE = 0;

counter = 1;
while (counter <= total_size)
    
    % get the new value from the sensor array  
    new_value = sensor_array (counter);
    
    % first case: counter < 5 : cannot do anything until we fill 
    % the sliding window -> just add to the temporal array 
    if (counter < temporal_size)
        temporal_array (counter) = new_value;
    else
        % if the counter is equal to 5 (add to temporal array)
        % or greater (shift the temporal array to the left then add)
        if (counter > temporal_size)
            % shift the array to the left
            for i=2:temporal_size
                temporal_array(i-1) = temporal_array(i);
            end % end for 
        end % end if 
        
        % insert the new value to the last element in the temporal array
        temporal_array (temporal_size) = new_value;
        
        % calculate the Mean Absolute Error for the temporal array
        [average, MAE] = get_MAE(temporal_array, temporal_size);
        
        % check if the mean absolute error meets the threshold condition
        if (MAE <= 5)
            result_value = average;
            result_MAE = MAE; 
            % break from the while loop 
            break;
        else
            % MAE and mean calculated didn't meet the condition
            % add average of array to candidtates and its error to scores  
            scores_array (scores_counter) = MAE;
            candidates(scores_counter) = average;
            scores_counter = scores_counter + 1;
        end
    end 
        
    % increment the overall counter
    counter = counter + 1;
end % end while 

% loop ended check the counter value
% if counter is smaller than the total, this means that 
% a stable array was found before reading all values
if (counter < total_size)
    disp("Result found before loop ended : ");
    disp(counter);
    disp(result_value);
    disp(result_MAE); 
else
    % the loop ended without meeting the stability condition
    % get the candidate value (average of temporal array) with minimum MAE
    disp("Loop ended: ");
    % get the index of the minimum score (minimum error)
    [min_error_value, min_error_index] = get_min(scores_array, scores_size);
    result_value = candidates (min_error_index);
    result_MAE = min_error_value;
    disp (result_value);
    disp(result_MAE);
end

% plot for demonstration 
detection = zeros (1,total_size);
detection (counter) = 1;

subplot(2,1,1);
plot(sensor_array);
subplot(2,1,2);
plot(detection);