# Detect the first stable stream of measurements arriving from a sensor 

While streaming data from a sensor, it is often desired to detect the first set of stable measurments. This set could be represented as an array of values having a Mean Absolute Error (MAE) that is less than a certain threshold. This indicates their stability. 

This function is used to detect a stable array of values once it arrives in steaming data. 

It uses a sliding window, calculating the mean absolute error after receiving each new value and stops when the MAE matches a threshold condition. If a certain number of values was received and none matched the condition, it finds the average of the window that showed the minimum Mean Absolute Error.

[![View Detect a stable set of values in streaming data on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/78574-detect-a-stable-set-of-values-in-streaming-data)
