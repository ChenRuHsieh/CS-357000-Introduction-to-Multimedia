function [output] = keepTheLowerFrequency(input,keepRange)
    [M,N] = size(input);
    output = zeros(M,N,'double');
    output(1 : keepRange, 1:keepRange) = input(1 : keepRange, 1 : keepRange);
end

