function [output] = NoiseDithering(input)
% input : gray img, type = double
% output : gray img, type = double
[M,N] = size(input);
output = zeros(M,N,'double');
for i = 1 : M
    for j = 1: N
        threshold = rand(1);
        if input(i,j) > threshold
            output(i,j) = 1;
        else
            output(i,j) = 0;
        end
    end
end

end

