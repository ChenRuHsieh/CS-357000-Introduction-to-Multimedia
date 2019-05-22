function residualIMG = ResidualImage(predictIMG, targetIMG)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
residualIMG_R = abs(predictIMG(:, :, 1) - targetIMG(:, :, 1));
residualIMG_G = abs(predictIMG(:, :, 2) - targetIMG(:, :, 2));
residualIMG_B = abs(predictIMG(:, :, 3) - targetIMG(:, :, 3));
residualIMG = residualIMG_R + residualIMG_G + residualIMG_B;
end

