function [F,U_L] = DCT2(f,keepRange)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
blockSize = 8;
[M,N] = size(f);
F = zeros(M,N,'double');
numBlockInRow = N / blockSize;
numBlockInCol = M / blockSize;
totalBlock = numBlockInRow * numBlockInCol;
cos_u = zeros(blockSize,1);
U_L = zeros(blockSize,blockSize,totalBlock,'double');
for i = 0 : numBlockInCol-1
    for j = 0 : numBlockInRow-1
        startRow = i * blockSize + 1;
        startCol = j * blockSize + 1;
        endRow = (i+1) * blockSize;
        endCol = (j+1) * blockSize;
        tmp_f = f(startRow : endRow , startCol : endCol);
        tmp_F = zeros(blockSize,blockSize,'double');
        currentBlock = i * numBlockInRow + j + 1;
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
            U_L(:,u+1,currentBlock) = a_u*cos_u;
        end

        for k = 0 : blockSize-1
            for l = 0 : blockSize-1
                Uk = U_L(:,k+1,currentBlock);
                Ul = U_L(:,l+1,currentBlock)';
                Ukl = Uk * Ul;
                tmp_F(k+1,l+1) = sum(sum(tmp_f .* Ukl));
            end
        end
        tmp_F = keepTheLowerFrequency(tmp_F,keepRange);
        F(startRow : endRow , startCol : endCol) = tmp_F;
    end
end
end

