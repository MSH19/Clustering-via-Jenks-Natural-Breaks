clc;
clear all;
close all;

filename = 'dataset.xlsx';
sheet = 'Sheet1';

% read the data into a table
data = readtable(filename, 'Sheet', sheet);

% extract the column of the time instants 
t = data{:, 1};

% define sliding window settings 
window_size = 10;
step_size = 5;

% define the signals length
data_length = height(data); % 250 in this dataset 

% Initialize an empty cell array to store the windowed data
temporal_window_set = {};
temporal_instants_set = {};

% define an array to store the overall results 
overall_results = [];

% loop into each signals, apply the algorithm and save the results 
for s=1:1:12

    % define the column name as mentioned in the data 
    signalName = ['S', num2str(s)];

    % extract signal 
    signal = data{:, signalName};

    % Initialize the index for the cell array
    temporal_window_index = 1;
    temporal_instants_index = 1;

    % Loop through the data array with the sliding window
    for start_index = 1:step_size:(data_length - window_size + 1)
    
        % Get the end index of the current window
        end_index = start_index + window_size - 1;
    
        % Extract the windowed segment
        current_window = signal(start_index:end_index);
        current_instants = t(start_index:end_index);
    
        % Store the windowed segment in the cell array
        temporal_window_set{temporal_window_index} = current_window;
        temporal_instants_set{temporal_instants_index} = current_instants;
    
        % Increment the window index
        temporal_window_index = temporal_window_index + 1;
        temporal_instants_index = temporal_instants_index + 1;
    end

    iterations = temporal_window_index - 1;

    % create an empty array to hold the results 
    results = zeros(1, iterations); 
    change_checks = zeros(1, iterations);

    for results_counter=1:iterations
    
        temporal_signal = temporal_window_set{results_counter};
        temporal_instants = temporal_instants_set{results_counter};

        if (abs(max(temporal_signal) - min(temporal_signal)) >= 5)

            % set 1 to the array of change checks 
            change_checks (results_counter) = 1;

            % get the change point with average comparison 
            [change_index, det] = getMaxDerivative(temporal_signal);
        
            if (det == 1)
                results(results_counter) = temporal_instants(change_index);
            end 

        end % end if 

    end % end for  

    overall_results = [overall_results; change_checks; results];
  
end % end signals 

% define the filename for the Excel file
filename = 'overall_results_10_sliding_derivative.xlsx';

% Write the results to the Excel file
writematrix(overall_results, filename);

disp ('Results created');
