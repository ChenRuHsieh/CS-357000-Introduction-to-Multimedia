function [f] = IDCT(F,U_L)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
blockSize = 4;
[M,N] = size(F)
f = zeros(blockSize,1,'single');

for u = 0 : blockSize-1
    f = f + F(u+1) .* U_L(:,u+1);
end

end

