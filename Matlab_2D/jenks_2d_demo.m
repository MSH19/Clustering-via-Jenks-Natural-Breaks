% Jenks Changepoint Detection Demo (2D)
% -------------------------------------
% This script applies the Jenks Natural Breaks method to detect changepoints
% in a 2D time-series signal (acceleration in X and Y axes).
%
% Data Source:
% UCI HAR Dataset (Human Activity Recognition Using Smartphones)
% https://archive.ics.uci.edu/ml/datasets/human+activity+recognition+using+smartphones
%
% Required Files:
% - body_acc_x_test.txt
% - body_acc_y_test.txt
% Place them in the current directory or update the file paths below.

clc;
close all;
clear all;

% Option 1: Load from original UCI HAR dataset
try
    acc_x = load('body_acc_x_test.txt');
    acc_y = load('body_acc_y_test.txt');
    sample_idx = 51;
    sample_x = acc_x(sample_idx, :);
    sample_y = acc_y(sample_idx, :);
    data2D = [sample_x' sample_y'];
catch
    % Option 2: Load from sample file
    fprintf('Dataset not found. Loading sample_data2D.mat...\n');
    load('sample_data2D.mat'); % Loads 'data2D'
    
    % Option 3: Define sample_x and sample_y from loaded data2D
    sample_x = data2D(:,1);
    sample_y = data2D(:,2);
end

% apply the 2D Jenks Natural Breaks method to detect the changepoint 
[best_idx, GF_combined, GF1, GF2] = jenks_2d(data2D);

change_index = best_idx;

% compute global y-axis limit for all GF plots
gf_max = max([GF1, GF2, GF_combined]) * 1.05;

% plot
figure('Units','normalized','OuterPosition',[0 0 1 1]);

subplot(5,1,1); plot(sample_x); title('X Acceleration Signal'); ylabel('X'); xline(change_index, 'r--');

subplot(5,1,2); 
plot(GF1); 
ylim([0 gf_max]);
title(sprintf('GF for X Signal (max = %.3f)', max(GF1))); 
ylabel('GF1'); 
xline(change_index, 'r--');

subplot(5,1,3); plot(sample_y); title('Y Acceleration Signal'); ylabel('Y'); xline(change_index, 'r--');

subplot(5,1,4); 
plot(GF2); 
ylim([0 gf_max]);
title(sprintf('GF for Y Signal (max = %.3f)', max(GF2))); 
ylabel('GF2'); 
xline(change_index, 'r--');

subplot(5,1,5); 
plot(GF_combined); 
ylim([0 gf_max]);
title(sprintf('Combined GF (Euclidean), changepoint at %d', change_index)); 
ylabel('GF'); 
xlabel('Time'); 
xline(change_index, 'r--');
