# 2D Changepoint Detection using Jenks Natural Breaks on UCI HAR Dataset

This MATLAB project implements an unsupervised changepoint detection method using the **Jenks Natural Breaks** algorithm on 2D time-series data (accelerometer X and Y axes) from the UCI Human Activity Recognition (HAR) dataset.

## Overview

- Processes acceleration signals from X and Y axes for a selected time window.
- Computes Goodness-of-Fit (GF) scores independently for each axis.
- Combines the GF scores using the Euclidean norm to identify the changepoint.
- Visualizes the signals, GF scores, and detected changepoint with clear plots.

## Dataset

The data used in this project comes from the [UCI Human Activity Recognition Using Smartphones Data Set](https://archive.ics.uci.edu/ml/datasets/human+activity+recognition+using+smartphones).

Required files (test subset):

- `body_acc_x_test.txt`
- `body_acc_y_test.txt`

These files can be found in the `test/Inertial Signals/` directory after downloading and extracting the dataset.

## Usage

1. Download and extract the UCI HAR dataset from the link above.
2. Place the required `.txt` files in your MATLAB working directory or update the paths accordingly in the script.
3. Run the provided MATLAB script (`jenks_2d_demo.m`) to see the changepoint detection on a sample signal.
4. If the dataset files are not available, the script can load a pre-saved sample `.mat` file (`sample_data2D.mat`) included in this repository.

## Files

- `jenks_2d_demo.m`: Main demo script.
- `jenks_2d.m`: Function applying Jenks method on 2D signals.
- `get_jenks_interface.m`: Function computing GF for 1D signals.
- `sample_data2D.mat` (optional): Pre-saved sample data for demo without full dataset.

## Citation

If you use this code or build upon it, please cite:

> Mahdi Saleh, “Clustering via Jenks Natural Breaks,” 2020, doi: [10.13140/RG.2.2.14166.68167](https://doi.org/10.13140/RG.2.2.14166.68167)

## License

This project is licensed under the MIT License.
