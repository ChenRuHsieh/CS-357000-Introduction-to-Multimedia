function [outputYIQ] = RGB2YIQ(inputRGB)
% input : RGB image, type = double
% output : YIQ image, type = double
[M,N,H] = size(inputRGB);
outputYIQ = zeros(M,N,H,'double');
%{
translateMatrix = [ 0.299,  0.587,  0.114; ...
                    0.596, -0.275, -0.321; ...
                    0.212, -0.523,  0.311];
%}
R = inputRGB(:,:,1);
G = inputRGB(:,:,2);
B = inputRGB(:,:,3);
outputYIQ(:,:,1) = 0.299.*R + 0.587.*G + 0.114.*B;
outputYIQ(:,:,2) = 0.596.*R - 0.275.*G - 0.321.*B;
outputYIQ(:,:,3) = 0.212.*R - 0.523.*G + 0.311.*B;


end

