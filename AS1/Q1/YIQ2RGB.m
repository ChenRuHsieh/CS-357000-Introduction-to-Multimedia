function [outputRGB] = YIQ2RGB(inputYIQ)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
[M,N,H] = size(inputYIQ);
outputRGB = zeros(M,N,H,'double');
translateMatrix = [ 0.299,  0.587,  0.114; ...
                    0.596, -0.275, -0.321; ...
                    0.212, -0.523,  0.311];
translateMatrix = inv(translateMatrix);  
Y = inputYIQ(:,:,1);
I = inputYIQ(:,:,2);
Q = inputYIQ(:,:,3);
outputRGB(:,:,1) = translateMatrix(1,1).*Y + translateMatrix(1,2).*I + translateMatrix(1,3).*Q;
outputRGB(:,:,2) = translateMatrix(2,1).*Y + translateMatrix(2,2).*I + translateMatrix(2,3).*Q;
outputRGB(:,:,3) = translateMatrix(3,1).*Y + translateMatrix(3,2).*I + translateMatrix(3,3).*Q;
end

