clc;
clear all;
close all;
plotNum = 1;
input = imread('cat2_gray.png'); % 讀取題目圖片
subplot(2,2,plotNum);imshow(input);title('Input');plotNum=plotNum+1;
[M,N] = size(input);
input = im2double(input);

outputNoiseDithering = NoiseDithering(input);
outputNoiseDithering = im2uint8(outputNoiseDithering);
subplot(2,2,plotNum);imshow(outputNoiseDithering);title('NoiseDithering');plotNum=plotNum+1;
imwrite(outputNoiseDithering,'NoiseDithering.png');

outputAverageDithering = AverageDithering(input);
outputAverageDithering = im2uint8(outputAverageDithering);
subplot(2,2,plotNum);imshow(outputAverageDithering);title('AverageDithering');plotNum=plotNum+1;
imwrite(outputAverageDithering,'AverageDithering.png');

outputErrorDiffusionDithering = ErrorDiffusionDithering(input);
outputErrorDiffusionDithering = im2uint8(outputErrorDiffusionDithering);
subplot(2,2,plotNum);imshow(outputErrorDiffusionDithering);title('ErrorDiffusionDithering');plotNum=plotNum+1;
imwrite(outputErrorDiffusionDithering,'ErrorDiffusionDithering.png');

