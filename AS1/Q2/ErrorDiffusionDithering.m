function [output] = ErrorDiffusionDithering(input)
% input : gray img, type = double
% output : gray img, type = double
[M,N] = size(input);
output = zeros(M,N,'double');
for i = 1 : M
    for j = 1 : N
        if input(i,j) < 0.5
            err = input(i,j);
        else
            err = input(i,j) - 1;
        end
        
        % 是否為最後一個col
        if j < N
            input(i,j+1) = input(i,j+1) + err*7/16;
        end
        % 是否為最後一個row 且 是否有上一個col    
        if (i < M) && (j > 1)
            input(i+1,j-1) = input(i+1,j-1) + err*3/16;
            input(i+1,j) = input(i+1,j) + err*5/16;
        end
        % 是否為最後一個row 且 是否有下一個col
        if (i < M) && (j < N)
            input(i+1,j+1) = input(i+1,j+1) + err*1/16;
        end
    end
end
for i = 1 : M
    for j = 1 : N
        if input(i,j) < 0.5
            output(i,j) = 0;
        else
            output(i,j) = 1;
        end
    end
end

end

