function [output] = Normalize(input, Min, Max)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

inputRange = max(input) - min(input);
outputRange = Max - Min;
output = Min + outputRange .* ( (input - min(input)) ./ inputRange );
end

