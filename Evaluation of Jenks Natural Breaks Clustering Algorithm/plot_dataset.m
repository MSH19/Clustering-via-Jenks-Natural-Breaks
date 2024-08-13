
% read data 
data = readtable('dataset.xlsx');

time_axis =  data{:, 'Time'};
data_length = height(data);

S1= data{:, 'S1'}; 
S2= data{:, 'S2'}; 
S3= data{:, 'S3'}; 
S4= data{:, 'S4'}; 
S5= data{:, 'S5'}; 
S6= data{:, 'S6'}; 
S7= data{:, 'S7'}; 
S8= data{:, 'S8'}; 
S9= data{:, 'S9'}; 
S10= data{:,'S10'}; 
S11= data{:,'S11'}; 
S12= data{:,'S12'};

% Create a figure
figure;

h1= plot(time_axis, S1, 'LineWidth', 2);
hold on;
h2= plot(time_axis, S2, 'LineWidth', 2);
h3= plot(time_axis, S3, 'LineWidth', 2);
h4= plot(time_axis, S4, 'LineWidth', 2);
h5= plot(time_axis, S5, 'LineWidth', 2);
h6= plot(time_axis, S6, 'LineWidth', 2);
h7= plot(time_axis, S7, 'LineWidth', 2);
h8= plot(time_axis, S8, 'LineWidth', 2);
h9= plot(time_axis, S9, 'LineWidth', 2);
h10= plot(time_axis, S10, 'LineWidth', 2);
h11= plot(time_axis, S11, 'LineWidth', 2);
h12= plot(time_axis, S12, 'LineWidth', 2);

% Add title and labels
% xlabel('Time (seconds)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
% ylabel('Voltage (VADC)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Voltage (VADC)', 'FontSize', 12);

% Add a legend
legend([h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12], {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10', 'S11', 'S12'}, 'FontSize', 10, 'FontWeight', 'bold', 'Orientation', 'horizontal');

% Set the axes properties for bigger and bold text
ax = gca;
ax.FontSize = 12;
% ax.FontWeight = 'bold';

% Optional: Add grid
grid on;
