%% Clean variables and screen
clc;
clear all;
close all;
%% Visualization parameters (Change it if you want)
% Condition = [Search method, range, block size]
Condition = ["FullSearch" ,  8,  8;
             "FullSearch" ,  8, 16;
             "FullSearch" , 16,  8;
             "FullSearch" , 16, 16;
             "threeStepSearch",  8,  8;
             "threeStepSearch",  8, 16;
             "threeStepSearch", 16,  8;
             "threeStepSearch", 16, 16];
fullSearchPSNR = zeros(4,1,'double');
fullSearchSAD = zeros(4,1,'double');
threeStepSearchPSNR = zeros(4,1,'double');
threeStepSearchSAD = zeros(4,1,'double');
%% 1. Read in input image
targetIMG = imread('frame439.jpg'); 
referenceIMG = imread('frame437.jpg');
[M, N, H] = size(targetIMG);

figure(1);
subplot(1,2,1);imshow(targetIMG);title('target image');
subplot(1,2,2);imshow(referenceIMG);title('reference image');

targetIMG = im2double(targetIMG);
referenceIMG = im2double(referenceIMG);

for i = 1 : 8
    %% Get Condition
    % tic
    searchMethod = Condition(i, 1);
    searchRange = str2double(Condition(i, 2));
    blockSize = str2double(Condition(i, 3));
    %% Prediction Image and SAD
    tic
    [predictIMG, MV_row, MV_col, SAD] = PredictImage(referenceIMG, targetIMG, searchRange, blockSize, searchMethod);
    toc
    figure(2);
    imgName = sprintf('predict image-%s-p=%d-size=%d.png', searchMethod, searchRange, blockSize);
    imshow(im2uint8(predictIMG));title(imgName);
    imwrite(im2uint8(predictIMG), imgName);
    %% Motion Vector
    figure(3);
    imgName = sprintf('motion vector-%s-p=%d-size=%d.png', searchMethod, searchRange, blockSize);
    im = image(im2uint8(targetIMG));im.AlphaData = 0.5;title(imgName);
    hold on
    quiver(1:blockSize:N, 1:blockSize:M, MV_col, MV_row)
    hold off
    quiverIMG = frame2im(getframe);
    imwrite(im2uint8(quiverIMG), imgName);
    %% Residual Image
    figure(4);
    residualIMG = ResidualImage(predictIMG, targetIMG);
    imgName = sprintf('residual image-%s-p=%d-size=%d.png', searchMethod, searchRange, blockSize);
    imshow(im2uint8(residualIMG));title(imgName);
    imwrite(im2uint8(residualIMG), imgName);
    %% PSNR and SAD
    if i <= 4
        fullSearchPSNR(i) = computePSNR(im2uint8(targetIMG), im2uint8(predictIMG));
        % fullSearchPSNR(i) = computePSNR(targetIMG, predictIMG);
        fullSearchSAD(i) = SAD; 
    else
        threeStepSearchPSNR(i-4) = computePSNR(im2uint8(targetIMG), im2uint8(predictIMG));
        % threeStepSearchPSNR(i-4) = computePSNR(targetIMG, predictIMG);
        threeStepSearchSAD(i-4) = SAD;
    end
    % PSNR(i) = psnr(im2uint8(targetIMG), im2uint8(predictIMG));
    % toc
end
%% Plot PSNR
figure(5);
x_labels = ["8, 8x8", "8, 16x16", "16, 8x8", "16, 16x16"];
x = 1 : 4;
plot(x, fullSearchPSNR, x, threeStepSearchPSNR);
title('PSNR');legend('Full Search','3-Step Search');
set(gca, 'Xtick',x,'XtickLabel',x_labels);

plotName = sprintf('PSNR.png');
saveas(gca, plotName);
%% Plot SAD
figure(6);
x_labels = ["8, 8x8", "8, 16x16", "16, 8x8", "16, 16x16"];
plot(x, fullSearchSAD, x, threeStepSearchSAD);
title('SAD');legend('Full Search','3-Step Search');
set(gca, 'Xtick',x,'XtickLabel',x_labels);

plotName = sprintf('SAD.png');
saveas(gca, plotName);
