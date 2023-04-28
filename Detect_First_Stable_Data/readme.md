# Detect the first stable stream of measurements 

While streaming data from a sensor, it is often desired to detect the first set of stable measurments. 
This stable set is described as an array of values having a Mean Absolute Error (MAE) that is less than a certain threshold. 

This function is used to detect the first stable set of values in steaming data. 
It uses a sliding window, calculating the mean absolute error after receiving each new value.
It stops when the MAE matches a threshold condition. 
If a certain number of values was received and none of the sets matched the condition, it returns the average value of the set that showed the minimum MAE.

[![View Detect a stable set of values in streaming data on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/78574-detect-a-stable-set-of-values-in-streaming-data)
