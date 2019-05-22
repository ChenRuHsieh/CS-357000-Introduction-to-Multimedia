function [dissimilarity] = Compare(referenceBlock, targetBlock)

dissimilarity = sum(sum(sum(abs(referenceBlock - targetBlock))));

end

