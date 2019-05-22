%% Clean variables and screen
clc;
clear all;
close all;
%% Visualization parameters (Change it if you want)
% Condition = [Search method, range, block size]
Condition = ["FullSearch" ,  8,  8];
%% 1. Read in input image
targetIMG = imread('frame439.jpg'); 
referenceIMG = imread('frame432.jpg');
[M, N, H] = size(targetIMG);

figure(1);
subplot(1,2,1);imshow(targetIMG);title('target image');
subplot(1,2,2);imshow(referenceIMG);title('reference image');

targetIMG = im2double(targetIMG);
referenceIMG = im2double(referenceIMG);

for i = 1 : 1
    %% Get Condition
    tic
    searchMethod = Condition(i, 1);
    searchRange = str2double(Condition(i, 2));
    blockSize = str2double(Condition(i, 3));
    %% Prediction Image and SAD
    [predictIMG, MV_row, MV_col, SAD] = PredictImage(referenceIMG, targetIMG, searchRange, blockSize, searchMethod);
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
    %% PSNR 
    PSNR = computePSNR(targetIMG, predictIMG)
    toc
end

