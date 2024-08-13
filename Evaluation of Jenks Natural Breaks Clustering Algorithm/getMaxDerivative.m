% Function to get the changepoint based on finding the maximum derivative
function [changePoint, detected] = getMaxDerivative(inputArray)

detected = 1;

% Calculate the derivative 
derivative = diff(inputArray);

maxValue =0;
maxIndex =1;

for i=1:length(derivative)
    if (derivative(i) >= maxValue)
        maxValue = derivative(i);
        maxIndex = i;
    end % end if
end % end for 

changePoint = maxIndex;

end % end function