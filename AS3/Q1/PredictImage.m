function [predictIMG, MV_row, MV_col, SAD] = PredictImage(referenceIMG, targetIMG, searchRange, blockSize, searchMethod)
[M, N, H] = size(targetIMG);
predictIMG = zeros(M, N, H, 'double');
blockNumInRow = M / blockSize;
blockNumInCol = N / blockSize;
MV_row = zeros(blockNumInRow, blockNumInCol, 'double');
MV_col = zeros(blockNumInRow, blockNumInCol, 'double');
SAD = 0;
if strcmp(searchMethod,'FullSearch') == 1
    for targetRowBlock = 1 : blockNumInRow
        for targetColBlock = 1 : blockNumInCol
            tmp_d = 1e10;
            tmpBlock = zeros(blockSize, blockSize, H, 'double');
            
            taStartPixel_row = (targetRowBlock-1)*blockSize  + 1;
            taStartPixel_col = (targetColBlock-1)*blockSize  + 1;
            taEndPixel_row   =  taStartPixel_row + blockSize - 1;
            taEndPixel_col   =  taStartPixel_col + blockSize - 1;
            targetBlock = targetIMG(taStartPixel_row : taEndPixel_row, taStartPixel_col : taEndPixel_col, :);
            for u = -searchRange : searchRange
                for v = -searchRange : searchRange
                    reStartPixel_row = (targetRowBlock-1)*blockSize + 1 + u;
                    reStartPixel_col = (targetColBlock-1)*blockSize + 1 + v;
                    reEndPixel_row =  reStartPixel_row + blockSize - 1;
                    reEndPixel_col =  reStartPixel_col + blockSize - 1;
                    if (reStartPixel_row < 1) || (reStartPixel_col < 1) || (reEndPixel_row > M) || (reEndPixel_col > N)
                        continue
                    end
                    % fprintf('reStartPixel_row = %d, reEndPixel_row = %d\n', reStartPixel_row, reEndPixel_row);
                    % fprintf('reStartPixel_col = %d, reEndPixel_col = %d\n', reStartPixel_col, reEndPixel_col);
                    referenceBlock = referenceIMG(reStartPixel_row : reEndPixel_row, reStartPixel_col : reEndPixel_col, :);
                    
                    [dissimilarity] = Compare(referenceBlock, targetBlock);
                    if dissimilarity < tmp_d
                        tmp_d = dissimilarity;
                        tmpBlock = referenceBlock;
                        tmp_row = reStartPixel_row;
                        tmp_col = reStartPixel_col;
                    end
                end
            end
            MV_row(targetRowBlock, targetColBlock) = tmp_row - taStartPixel_row;
            MV_col(targetRowBlock, targetColBlock) = tmp_col - taStartPixel_col;
            predictIMG(taStartPixel_row : taEndPixel_row, taStartPixel_col : taEndPixel_col, :) = tmpBlock;
            SAD = SAD + tmp_d;
        end
    end
elseif strcmp(searchMethod,'threeStepSearch') == 1
    stepNum = log2(searchRange);
    for targetRowBlock = 1 : blockNumInRow
        for targetColBlock = 1 : blockNumInCol
            tmpBlock = zeros(blockSize, blockSize, H, 'double');
            tmp_d = 1e10;
            
            taStartPixel_row = (targetRowBlock-1)*blockSize  + 1;
            taStartPixel_col = (targetColBlock-1)*blockSize  + 1;
            taEndPixel_row   =  taStartPixel_row + blockSize - 1;
            taEndPixel_col   =  taStartPixel_col + blockSize - 1;
            targetBlock = targetIMG(taStartPixel_row : taEndPixel_row, taStartPixel_col : taEndPixel_col, :);
            
            midStart_row = taStartPixel_row;
            midStart_col = taStartPixel_col;
            
            for i = stepNum-1 : -1 : 0
                stepRange = 2 ^ (i);
                for u = [-stepRange, 0, stepRange]
                    for v = [-stepRange, 0, stepRange]
                        reStartPixel_row = midStart_row + u;
                        reStartPixel_col = midStart_col + v;
                        reEndPixel_row =  reStartPixel_row + blockSize - 1;
                        reEndPixel_col =  reStartPixel_col + blockSize - 1;
                        
                        if (reStartPixel_row < 1) || (reStartPixel_col < 1) || (reEndPixel_row > M) || (reEndPixel_col > N)
                            continue
                        end
                        referenceBlock = referenceIMG(reStartPixel_row : reEndPixel_row, reStartPixel_col : reEndPixel_col, :);
                        
                        [dissimilarity] = Compare(referenceBlock, targetBlock);
                        if dissimilarity < tmp_d
                            tmp_d = dissimilarity;
                            tmpBlock = referenceBlock;
                            tmp_row = reStartPixel_row;
                            tmp_col = reStartPixel_col;
                        end
                    end
                end
                midStart_row = tmp_row;
                midStart_col = tmp_col;
            end
            MV_row(targetRowBlock, targetColBlock) = tmp_row - taStartPixel_row;
            MV_col(targetRowBlock, targetColBlock) = tmp_col - taStartPixel_col;
            predictIMG(taStartPixel_row : taEndPixel_row, taStartPixel_col : taEndPixel_col, :) = tmpBlock;
            SAD = SAD + tmp_d;
        end
    end
end

end

