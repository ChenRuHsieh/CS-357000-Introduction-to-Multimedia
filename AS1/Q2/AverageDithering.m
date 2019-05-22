function [output] = AverageDithering(input)
% input : gray img, type = double
% output : gray img, type = double
[M,N] = size(input);
output = zeros(M,N,'double');
threshold = mean(input(:));

for i = 1 : M
    for j = 1: N
        if input(i,j) > threshold
            output(i,j) = 1;
        else
            output(i,j) = 0;
        end
    end
end
end

