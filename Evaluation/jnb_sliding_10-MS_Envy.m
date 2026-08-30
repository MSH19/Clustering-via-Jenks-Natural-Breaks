clc; clear; close all;

% Load test data
x = load('total_acc_x_test.txt');
y = load('total_acc_y_test.txt');
z = load('total_acc_z_test.txt');
labels = load('y_test.txt');
n_windows = size(x,1);

% Compute smoothed magnitude
mean_mag = mean(sqrt(x.^2 + y.^2 + z.^2), 2);
smoothed_mag = movmean(mean_mag, 5);

% Parameters
win_size = 150; step = 5; min_dist = 5;

% --- Jenks Method (max GF only) ---
best_idxs_jenks = detect_sliding_max(@get_jenks_interface, smoothed_mag, win_size, step, min_dist, true);

% --- Differential Method ---
diff_signal = [0; diff(smoothed_mag).^2];
thresh = mean(diff_signal) + std(diff_signal);
best_idxs_diff = find(diff_signal > thresh);
best_idxs_diff = best_idxs_diff([true; diff(best_idxs_diff) > min_dist]);

% Ground truth
true_transitions = find(diff(labels) ~= 0);

% Binary signals
binary_true  = to_binary(labels);
binary_jenks = to_binary_from_idxs(best_idxs_jenks, n_windows);
binary_diff  = to_binary_from_idxs(best_idxs_diff, n_windows);

% Plot
figure;
plot(binary_true, 'k', 'LineWidth', 1.3); hold on;
plot(binary_jenks, 'r--', 'LineWidth', 1.3);
plot(binary_diff, 'b-.', 'LineWidth', 1.3);
ylim([-0.2 1.2]); xlabel('Window Index'); ylabel('Binary State');
legend('Ground Truth', 'Jenks (max GF)', 'Differential');
title('Transition Detection: Jenks vs Differential');

% Evaluate
evaluate_and_print(true_transitions, best_idxs_jenks, 'Jenks (max GF)');
evaluate_and_print(true_transitions, best_idxs_diff, 'Differential');

% --- FUNCTIONS ---

function best_idxs = detect_sliding_max(func_handle, data, win, step, min_dist, use_threshold)
    best_idxs = [];
    for i = 1:step:(length(data) - win)
        segment = data(i:i + win - 1);
        [~, GF] = func_handle(segment);

        if use_threshold
            threshold = 0.3 * max(GF);
            if max(GF) < threshold
                continue;
            end
        end

        [~, peak] = max(GF);
        global_idx = i + peak - 1;
        best_idxs = [best_idxs; global_idx];
    end
    best_idxs = unique(best_idxs);
    best_idxs = best_idxs([true; diff(best_idxs) > min_dist]);
end

function [SDCM, GF] = get_jenks_interface(A)
    total = length(A);
    SDCM = zeros(1,total); GF = zeros(1,total);
    SDAM = sum((A - mean(A)).^2);
    for i = 1:total-1
        s1 = sum((A(1:i) - mean(A(1:i))).^2);
        s2 = sum((A(i+1:end) - mean(A(i+1:end))).^2);
        SDCM(i) = s1 + s2;
        GF(i) = (SDAM - SDCM(i)) / SDAM;
    end
end

function binary = to_binary(labels)
    binary = zeros(length(labels), 1); s = 0; binary(1) = s;
    for i = 2:length(labels)
        if labels(i) ~= labels(i-1), s = 1 - s; end
        binary(i) = s;
    end
end

function binary = to_binary_from_idxs(idxs, n)
    binary = zeros(n, 1); s = 0; binary(1) = s;
    for i = 2:n
        if ismember(i, idxs), s = 1 - s; end
        binary(i) = s;
    end
end

function evaluate_and_print(true_transitions, detected_idxs, method_name)
    tolerance = 3; TP = 0; FP = 0;
    for i = 1:length(true_transitions)
        if any(abs(detected_idxs - true_transitions(i)) <= tolerance)
            TP = TP + 1;
        end
    end
    FN = length(true_transitions) - TP;
    for i = 1:length(detected_idxs)
        if all(abs(true_transitions - detected_idxs(i)) > tolerance)
            FP = FP + 1;
        end
    end
    precision = TP / max((TP + FP), eps);
    recall    = TP / max((TP + FN), eps);
    F1 = 2 * precision * recall / max((precision + recall), eps);
    fprintf('\n--- %s Detection Evaluation ---\n', method_name);
    fprintf('True Positives: %d\n', TP);
    fprintf('False Positives: %d\n', FP);
    fprintf('False Negatives: %d\n', FN);
    fprintf('Precision: %.2f\n', precision);
    fprintf('Recall   : %.2f\n', recall);
    fprintf('F1 Score : %.2f\n', F1);
end
