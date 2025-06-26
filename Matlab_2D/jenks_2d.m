function [best_idx, GF_combined, GF1, GF2] = jenks_2d(data2D)
    % Apply Jenks method to each dimension
    [~, GF1] = get_jenks_interface(data2D(:,1));
    [~, GF2] = get_jenks_interface(data2D(:,2));

    % Combine Goodness-of-Fit (Euclidean norm)
    GF_combined = sqrt(GF1.^2 + GF2.^2);

    % Get best changepoint index
    [~, best_idx] = max(GF_combined);
end