clear all; close all; clc

img = im2double(imread('./bg.png'));
[h, w, ~] = size(img);
points = importdata('./points.txt');
%% Curve Computation
n = size(points, 1); % number of input points
sampleRange = 4;
setNum = ((n - 4) / 3) + 1; % 1~4, 4~7,...,
%==============================================================%
% Code here. Store the results as `result1`, `result2`
M = [-1,  3, -3,  1;
      3, -6,  3,  0;
     -3,  3,  0,  0;
      1,  0,  0,  0];
result1 = [];
result2 = [];
for detail = [0.2, 0.002]
    smaplePointNum = 1/detail + 1;
    for i = 0 : setNum-1
        % get point
        curve = zeros(smaplePointNum, 2, 'double');
        p = zeros(sampleRange, 2, 'double');
        for j = 1 : sampleRange
            p(j, :) = points(i*3 + j, :);
        end
        % 
        smaplePoint = 1;
        for t = 0 : detail : 1
            T = [t^3, t^2, t^1, t^0];
            curve(smaplePoint, :) = T * M * p;
            smaplePoint = smaplePoint + 1;
        end
        if detail == 0.2
            result1 = cat(1, result1, curve);% shaped [?, 2]
        elseif detail == 0.002
            result2 = cat(1, result2, curve);% shaped [?, 2]
        end
    end
 end
%==============================================================%

% Draw the polygon of the curve
f = figure;
subplot(1, 2, 1);
imshow(img);
hold on
plot(points(:, 1), points(:, 2), 'r.');
plot(result1(:, 1), result1(:, 2), 'g-');
title('1-(a) detail = 0.2');

subplot(1, 2, 2);
imshow(img);
hold on
plot(points(:, 1), points(:, 2), 'r.');
plot(result2(:, 1), result2(:, 2), 'g-');
title('1-(a) detail = 0.002');
saveas(f, '1a.png');

%% Scaling
points = points .* 4;
img2 = imresize(img, 4, 'nearest');

%==============================================================%
result = [];
detail = 0.002;
smaplePointNum = 1/detail + 1;
for i = 0 : setNum-1
    % get point
    curve = zeros(smaplePointNum, 2, 'double');
    p = zeros(sampleRange, 2, 'double');
    for j = 1 : sampleRange
        p(j, :) = points(i*3 + j, :);
    end
    % 
    smaplePoint = 1;
    for t = 0 : detail : 1
        T = [t^3, t^2, t^1, t^0];
        curve(smaplePoint, :) = T * M * p;
        smaplePoint = smaplePoint + 1;
    end
    result = cat(1, result, curve);% shaped [?, 2]
end
%==============================================================%
f = figure;
imshow(img2);
hold on
plot(points(:, 1), points(:, 2), 'r.');
plot(result(:, 1), result(:, 2), 'g-');
title('1-(b) detail = 0.002');
saveas(f, '1b.png');