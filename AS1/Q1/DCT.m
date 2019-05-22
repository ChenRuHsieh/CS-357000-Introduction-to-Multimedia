function [F,U_L] = DCT(f)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
blockSize = 4;
[M,N] = size(f)
F = zeros(blockSize,1,'single');

cos_u = zeros(blockSize,1);
U_L = zeros(blockSize,blockSize);
for u = 0 : blockSize-1
    if u == 0
        C = 1/sqrt(2);
    else
        C = 1;
    end
    a_u = sqrt(2)*C/sqrt(blockSize);
    for r = 0 : blockSize-1
        cos_u(r+1,1) = cos((2*r+1)*u*pi/(2*blockSize)); 
    end
    U_L(:,u+1) = a_u .* cos_u;
end

for u = 0 : blockSize-1
    F(u+1) = sum(f .* U_L(:,u+1));
end
end

