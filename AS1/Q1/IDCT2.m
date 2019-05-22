function [f] = IDCT2(F,U_L)
blockSize = 8;
[M,N] = size(F);
f = zeros(M,N,'double');
numBlockInRow = N / blockSize;
numBlockInCol = M / blockSize;
for i = 0 : numBlockInCol-1
    for j = 0 : numBlockInRow-1
        startRow = i * blockSize + 1;
        startCol = j * blockSize + 1;
        endRow = (i+1) * blockSize;
        endCol = (j+1) * blockSize;
        tmp_F = F(startRow : endRow , startCol : endCol);
        tmp_f = zeros(blockSize,blockSize,'double');
        currentBlock = i * numBlockInRow + j + 1;
        for k = 0 : blockSize-1
            for l = 0 : blockSize-1
                Uk = U_L(:,k+1,currentBlock);
                Ul = U_L(:,l+1,currentBlock)';
                Ukl = Uk * Ul;
                tmp_f = tmp_f + tmp_F(k+1,l+1) .* Ukl;
            end
        end
        f(startRow : endRow , startCol : endCol) = tmp_f;
    end
end

end

