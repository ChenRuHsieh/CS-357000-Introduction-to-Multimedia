clc;
clear all;
close all;
plotNum = 1;
input = imread('cat1.png'); % 讀取題目圖片
subplot(2,4,plotNum);imshow(input);title('Input');plotNum=plotNum+1;
[M,N,H] = size(input);
inputRGB = im2double(input);
inputYIQ = RGB2YIQ(inputRGB);


inputRGB_R = inputRGB(:,:,1);
inputRGB_G = inputRGB(:,:,2);
inputRGB_B = inputRGB(:,:,3);
for keepRange = [2,4,8]
    outputRGB = zeros(M,N,3,'double');
    [DCT2_R, U_R] = DCT2(inputRGB_R,keepRange);
    [DCT2_G, U_G] = DCT2(inputRGB_G,keepRange);
    [DCT2_B, U_B] = DCT2(inputRGB_B,keepRange);
    [IDCT2_R] = IDCT2(DCT2_R,U_R);
    [IDCT2_G] = IDCT2(DCT2_G,U_R);
    [IDCT2_B] = IDCT2(DCT2_B,U_R);
    
    outputRGB(:,:,1) = IDCT2_R;
    outputRGB(:,:,2) = IDCT2_G;
    outputRGB(:,:,3) = IDCT2_B;
    outputRGB = im2uint8(outputRGB);
    subplot(2,4,plotNum);imshow(outputRGB);
    switch keepRange
        case 2
            title('RGB Keep Range = 2');
            imwrite(outputRGB,'RGB Keep Range = 2.png');
        case 4
            title('RGB Keep Range = 4');
            imwrite(outputRGB,'RGB Keep Range = 4.png');
        case 8
            title('RGB Keep Range = 8');
            imwrite(outputRGB,'RGB Keep Range = 8.png');
    end
    plotNum=plotNum+1;
    inputRGB = im2uint8(inputRGB);
    PSNR_RGB(keepRange) = computePSNR(inputRGB, outputRGB);
end

inputYIQ_Y = inputYIQ(:,:,1);
inputYIQ_I = inputYIQ(:,:,2);
inputYIQ_Q = inputYIQ(:,:,3);
for keepRange = [2,4,8]
    outputYIQ = zeros(M,N,3,'double');
    [DCT2_Y, U_Y] = DCT2(inputYIQ_Y,keepRange);
    [DCT2_I, U_I] = DCT2(inputYIQ_I,keepRange);
    [DCT2_Q, U_Q] = DCT2(inputYIQ_Q,keepRange);
    [IDCT2_Y] = IDCT2(DCT2_Y,U_Y);
    [IDCT2_I] = IDCT2(DCT2_I,U_I);
    [IDCT2_Q] = IDCT2(DCT2_Q,U_Q);
    
    outputYIQ(:,:,1) = IDCT2_Y;
    outputYIQ(:,:,2) = IDCT2_I;
    outputYIQ(:,:,3) = IDCT2_Q;
    outputYIQ = YIQ2RGB(outputYIQ);
    outputYIQ = im2uint8(outputYIQ);
    subplot(2,4,plotNum);imshow(outputYIQ);
    switch keepRange
        case 2
            title('YIQ Keep Range = 2');
            imwrite(outputYIQ,'YIQ Keep Range = 2.png');
        case 4
            title('YIQ, Keep Range = 4');
            imwrite(outputYIQ,'YIQ Keep Range = 4.png');
        case 8
            title('YIQ, Keep Range = 8');
            imwrite(outputYIQ,'YIQ Keep Range = 8.png');
    end
    plotNum=plotNum+1;
    inputRGB = im2uint8(inputRGB);
    PSNR_YIQ(keepRange) = computePSNR(inputRGB, outputYIQ);
end