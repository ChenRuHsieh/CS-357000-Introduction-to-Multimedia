clc;
clear all;
close all;
plotNum = 1;
input = imread('cat3_LR.png'); % 讀取題目圖片
subplot(2,4,plotNum);imshow(input);title('Input');plotNum=plotNum+1;
[M,N,H] = size(input);

input = im2double(input);
input_R = input(:,:,1);
input_G = input(:,:,2);
input_B = input(:,:,3);

for hsize = [3,5,7]
    output = zeros(M,N,3,'double');
    G = fspecial('gaussian',hsize,1);
    output_R = Cov2(input_R,G);
    output_G = Cov2(input_G,G);
    output_B = Cov2(input_B,G);

    output(:,:,1) = output_R;
    output(:,:,2) = output_G;
    output(:,:,3) = output_B;
    output = im2uint8(output);
    
    subplot(2,4,plotNum);imshow(output);
    switch hsize
        case 3
            title('hsize = 3x3');
            imwrite(output,'hsize = 3x3.png');
        case 5
            title('hsize = 5x5');
            imwrite(output,'hsize = 5x5.png');
        case 7
            title('hsize = 7x7');
            imwrite(output,'hsize = 7x7.png');
    end
    plotNum=plotNum+1;
    PSNR_hsize(hsize) = computePSNR(im2uint8(input), output);
end

for sigma = [1,5,10]
    output = zeros(M,N,3,'double');
    G = fspecial('gaussian',5,sigma);
    output_R = Cov2(input_R,G);
    output_G = Cov2(input_G,G);
    output_B = Cov2(input_B,G);

    output(:,:,1) = output_R;
    output(:,:,2) = output_G;
    output(:,:,3) = output_B;
    output = im2uint8(output);
    
    subplot(2,4,plotNum);imshow(output);
    switch sigma
        case 1
            title('sigma = 1');
            imwrite(output,'sigma = 1.png');
        case 5
            title('sigma = 5');
            imwrite(output,'sigma = 5.png');
        case 10
            title('sigma = 10');
            imwrite(output,'sigma = 10.png');
    end
    plotNum=plotNum+1;
    PSNR_sigma(sigma) = computePSNR(im2uint8(input), output);
end
