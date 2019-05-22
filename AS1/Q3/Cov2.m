function [output] = Cov2(input,mask)
[M,N] = size(input);
[m,n] = size(mask);
output = zeros(M,N,'double');
padSize = (m-1) / 2;
inputPadding = padarray(input,[padSize,padSize],0,'both');

for i = 1 : M
    for j = 1 : N
        newValue = 0;
        for s = 1 : m
            for t = 1 : n
                newValue = newValue + mask(s,t) *  inputPadding(i+s-1,j+t-1);
            end
        end
        output(i,j) = newValue;
    end
end

end

