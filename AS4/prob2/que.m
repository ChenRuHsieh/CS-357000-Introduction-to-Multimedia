clear all; close all; clc; 

%% Read OBJ file
obj = readObj('trump.obj');
%==============================================================%
% Code here. Move object center to (0, 0)
curCenter = zeros(1,3,'double');
curCenter(1,1) = (max(obj.v(:, 1)) + min(obj.v(:, 1))) / 2;
curCenter(1,2) = (max(obj.v(:, 2)) + min(obj.v(:, 2))) / 2;
curCenter(1,3) = (max(obj.v(:, 3)) + min(obj.v(:, 3))) / 2;

moveVector = -curCenter;
[vertexNum, ~] = size(obj.v);
for i = 1 : vertexNum
    obj.v(i, :) = obj.v(i, :) + moveVector;
end
tval = display_obj(obj,'tumpLPcolors.png');

%==============================================================%
%% a.
f = figure; 
trisurf(obj.f.v, obj.v(:,1), obj.v(:,2), obj.v(:,3), ...
    'FaceVertexCData', tval, 'FaceColor', 'interp', 'EdgeAlpha', 0);
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
saveas(f, '2a.png');
hold on
%==============================================================%
%% b.
% First, create a 100-by-100 image to texture the cone with:

H = repmat(linspace(0, 1, 100), 100, 1);     % 100-by-100 hues
S = repmat([linspace(0, 1, 50) ...           % 100-by-100 saturations
            linspace(1, 0, 50)].', 1, 100);  %'
V = repmat([ones(1, 50) ...                  % 100-by-100 values
            linspace(1, 0, 50)].', 1, 100);  %'
hsvImage = cat(3, H, S, V);                  % Create an HSV image
C = hsv2rgb(hsvImage);                       % Convert it to an RGB image

% Next, create the conical surface coordinates:

theta = linspace(0, 2*pi, 100);  % Angular points
X = [zeros(1, 100); ...          % X coordinates
     cos(theta); ...
     zeros(1, 100)];
Y = [zeros(1, 100); ...          % Y coordinates
     sin(theta); ...
     zeros(1, 100)];
Z = [ones(2, 100); ...        % Z coordinates
     zeros(1, 100)];

% Finally, plot the texture-mapped surface:
f = figure; 
trisurf(obj.f.v, obj.v(:,1), obj.v(:,2), obj.v(:,3), ...
    'FaceVertexCData', tval, 'FaceColor', 'interp', 'EdgeAlpha', 0);
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
hold on
surf(X, Y, Z-1.4, C, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
axis equal
saveas(f, '2b.png');

%==============================================================%
%% c. 
f = figure;
subplot(1,2,1);
trisurf(obj.f.v, obj.v(:,1), obj.v(:,2), obj.v(:,3), ...
    'FaceVertexCData', tval, 'FaceColor', 'interp', 'EdgeAlpha', 0);
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
hold on
surf(X, Y, Z-1.4, C, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
axis equal
light('Position',[0 0 1],'Style','local');
title('Positional Light');
% lighting none

subplot(1,2,2);
trisurf(obj.f.v, obj.v(:,1), obj.v(:,2), obj.v(:,3), ...
    'FaceVertexCData', tval, 'FaceColor', 'interp', 'EdgeAlpha', 0);
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
hold on
surf(X, Y, Z-1.4, C, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
axis equal
light('Position',[0 0 1], 'Style','infinite');
title('Directional Light');

saveas(f, '2c.png');
%% d.
f = figure;

coefficient = [1.0, 0.0, 0.0;
               0.1, 1.0, 0.0;
               0.1, 0.1, 1.0;
               0.1, 0.5, 1.0];
for i = 1 : 4
    subplot(2,2,i);
    trisurf(obj.f.v, obj.v(:,1), obj.v(:,2), obj.v(:,3), ...
        'FaceVertexCData', tval, 'FaceColor', 'interp', 'EdgeAlpha', 0);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    axis equal;
    hold on
    surf(X, Y, Z-1.4, C, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
    axis equal
    light('Position',[-1 0 0],'Style','local');
    material(coefficient(i, :)); 
    titleStr = sprintf("k_a = %.1f, k_d = %.1f, k_s = %.1f", coefficient(i, 1), coefficient(i, 2), coefficient(i, 3));
    title(titleStr);
end

saveas(f, '2d.png');