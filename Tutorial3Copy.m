clc
clear variables
close all
heart = resampleDicom('05.dcm');

centerH = floor(heart.height/2);
centerW = floor(heart.width/2);
centerD = floor(heart.depth/2);

extractW = heart.data(centerW,:,:,1);
extractH = heart.data(:,centerH,:,1);
extractD = heart.data(:,:,centerD,1);

imgW = squeeze(extractW);
imgH = squeeze(extractH);
imgD = squeeze(extractD); 

d = floor(heart.depth);
w = floor(heart.width);
h = floor(heart.height);


widthdistance = heart.widthspan; %cm
heightdistance = heart.heightspan; %cm
depthdistance = heart.depthspan; %cm


h2 = figure(2);
% width
sp2_1 = subplot(2, 2, 1);
imshow(imgW', []);
title('Width');
line([centerH centerH], [1 d],'Color','red','LineWidth',2) 
line([1 h], [centerD centerD],'Color','green','LineWidth',2)
addborder(1, d, h, 1, 'blue');

% height
sp2_2 = subplot(2, 2, 2);
imshow(imgH', []);
title('Height');
line([centerW centerW], [1 d],'Color','blue','LineWidth',2) 
line([1 w], [centerD centerD],'Color','green','LineWidth',2)
addborder(1, d, w, 1, 'red');


% depth
sp2_3 = subplot(2, 2, 3);
imshow(imgD', []);
title('Depth');
line([centerW centerW], [1 h],'Color','blue','LineWidth',2) 
line([1 w], [centerH centerH],'Color','red','LineWidth',2)
addborder(1, h, w, 1, 'green');


[x, y] = ginput(2);

% Identify the subplot user clicked on
ax = gca; % Get the current axes handle
if ax == sp2_1
    dimension = 'W';
    depthIndex = centerW;
elseif ax == sp2_2
    dimension = 'H';
    depthIndex = centerH;
elseif ax == sp2_3
    dimension = 'D';
    depthIndex = centerD;
else
    error('Unexpected axes handle.');
end

% Calculate the rotation axis in 3D space
p1 = [x(1), y(1), depthIndex];
p2 = [x(2), y(2), depthIndex];
rotationAxis = p2 - p1;
rotationAxis = rotationAxis / norm(rotationAxis); % Normalize the axis


linemaker(x(1), y(1), x(2), y(2));

midpoint = midptofline(x(1), y(1), x(2), y(2));
lengthofline = distanceinpixels(x(1), y(1), x(2), y(2));

centerX = midpoint(1);
centerY = midpoint(2);
radiusofcircle = lengthofline/8;
circlemakerforlines(centerX, centerY, radiusofcircle);

% Default translations
d_D = 0;
d_H = 0;
d_W = 0;

% Compute translations based on selected dimension
switch dimension
    case 'W'
        d_D = 2 * (heart.depth/2 - centerY);
        d_W = 2 * (heart.width/2 - centerX);
        d_H = 0;
    case 'H'
        d_D = 2 * (heart.depth/2 - centerY); 
        d_H = 2 * (heart.width/2 - centerX); 
        d_W = 0; 
    case 'D'
        d_H = 2 * (heart.depth/2 - centerY);
        d_W = 2 * (heart.width/2 - centerX);
        d_D = 0; 
end

% Compute the translated volume
vol_transfull = imtranslate(heart.data(:,:,:,1), [d_W d_H d_D], 'OutputView', 'full', 'FillValues', 128);

% Extract the relevant slice based on the selected dimension
switch dimension
    case 'W'
        extract_transfull = vol_transfull(centerW, :, :, 1);
        originalTitle = get(get(sp2_1, 'Title'), 'String');
    case 'H'
        extract_transfull = vol_transfull(:, centerH, :, 1);
        originalTitle = get(get(sp2_2, 'Title'), 'String');
    case 'D'
        extract_transfull = vol_transfull(:, :, centerD, 1);
        originalTitle = get(get(sp2_3, 'Title'), 'String');
end

img_transfull = squeeze(extract_transfull);
figure(2)
imshow(img_transfull', []);
title(originalTitle); % Set the original title

[newrows, newcols, ~] = size(img_transfull');
newcenter_y = newrows / 2;
newcenter_x = newcols / 2;

circlemakerforlines(newcenter_x, newcenter_y, radiusofcircle);



% Calculate the angle with the vertical axis
deltaY = y(2) - y(1);
deltaX = x(2) - x(1);
angle = atan2(deltaY, deltaX) - pi/2; % Subtracting pi/2 gives the angle with respect to the vertical axis
angleDeg = rad2deg(angle); % Convert to degrees

% Rotate the entire 3D volume
vol_rotated = imrotate3(heart.data(:,:,:,1), angleDeg, rotationAxis, 'linear', 'loose', 'FillValues', 100);


% Extract the relevant slice based on the selected dimension
switch dimension
    case 'W'
        img_rotated = squeeze(vol_rotated(centerW, :, :, 1));
    case 'H'
        img_rotated = squeeze(vol_rotated(:, centerH, :, 1));
    case 'D'
        img_rotated = squeeze(vol_rotated(:, :, centerD, 1));
end

% Display the rotated image slice
figure(2);
imshow(img_rotated', []);
title('Rotated Image');

% Draw the green circle at the center
[rotatedRows, rotatedCols, ~] = size(img_rotated');
rotatedCenter_y = rotatedRows / 2;
rotatedCenter_x = rotatedCols / 2;

circlemakerforlines(rotatedCenter_x, rotatedCenter_y, radiusofcircle);