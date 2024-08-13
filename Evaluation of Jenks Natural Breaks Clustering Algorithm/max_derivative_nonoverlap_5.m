clc;
clear all;
close all;

% dataset file name 
filename = 'dataset.xlsx';
sheet = 'Sheet1';

% read the data into a table
data = readtable(filename, 'Sheet', sheet);

% extract the time instants column  
time_axis =  data{:, 'Time'};

% define the non-overlapping window size
nonoverlapping_window_size = 5;

% for later use, define an increment step 
increment_step = nonoverlapping_window_size - 1;

% define the signals length
data_length = height(data); % 250 in this dataset  

% calculate the number of temporal windows that we need to analyze 
% example: 250 (data length) / 5 (temporal window size) = 50 windows 
iterations = data_length / nonoverlapping_window_size;

% create empty arrays to store the results
selected_changepoints = zeros(1, iterations + 1);
change_checks = zeros(1, iterations + 1);

% define the change detection threshold 
change_threshold = 5;

% define an array to store the overall results 
overall_results = [];

% loop into each signals, apply the algorithm and save the results 
for s=1:1:12

    % define the column name as mentioned in the data 
    signalName = ['S', num2str(s)];

    % extract a signal 
    signal = data{:, signalName};
    
    results_index = 1;
    signal_index= 1;

    % analyze the signal in temproal windows 
    for i=1:iterations

        % fill the window with data  
        temporal_window = signal(signal_index:signal_index+increment_step);

        % fill the temporal window indexes in separate array 
        temporal_instants = time_axis(signal_index:signal_index+increment_step);
        
        % check if a change occurred within the examined window
        
        if (abs(max(temporal_window) - min(temporal_window)) >= change_threshold)
            
            % set 1 to the array of change checks 
            change_checks (results_index) = 1;

            % get the change point with the maximum derivative method 
            [change_index, det] = getMaxDerivative(temporal_window);

            if (det == 1)
                selected_changepoints(results_index) = temporal_instants(change_index);
            end 
            
        end

        % increment sliding window  
        signal_index = signal_index + nonoverlapping_window_size;

        if (results_index < iterations)
            results_index = results_index + 1;
        else 
            % append the signal number to the end of each results array so
            % that we can identfiy them in the results file 
            results_index = results_index + 1;
            change_checks (results_index) = s;
            selected_changepoints(results_index) = s;
        end % end if 

    end % end for iterations 

    % append results to the overall_results 
    overall_results = [overall_results; change_checks; selected_changepoints];

end % end loop of all signals  

% Define the filename for the Excel file
filename = 'overall_results_5_nonoverlap_derivative.xlsx';

% Write the results to the Excel file
writematrix(overall_results, filename);

disp ('Results created');
