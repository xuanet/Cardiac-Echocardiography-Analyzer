clc;
clear variables;
close all;

% About

disp('Aortic Pressure from Echo');
disp('Jose, Kevin, Nidhi');

% Setting figure size and pos

% screen = get(0, 'screensize');
% screenWidth = screen(3);
% screenHeight = screen(4);
% figDimension = floor(min(screenWidth, screenHeight)/1.5);
% xpos = floor((screenWidth-figDimension)/2);
% ypos = floor((screenHeight-figDimension)/2);
% set(groot, 'defaultFigureUnits', 'pixels', 'defaultFigurePosition', [xpos ypos figDimension figDimension]);

% Importing echo

heart = resampleDicom('002A.dcm');
fr = 15;
cmPerPixel = heart.depthspan/heart.depth;

% Find aorta cross-section area on frame 2 (1 frame after ED)

aortaArea = AorticArea(heart.data(:,:,:,2), cmPerPixel);

% Find the LV volume in each frame. First reorient ventricle then integrate

volumeArr = zeros(1, heart.NumVolumes);

for time = 1:heart.NumVolumes
    fprintf("\nCurrent time slice: %d\n", time);
    currentTimeSlice = heart.data(:,:,:,time);
    [reorientedVentricle, d] = ReorientVentricle(currentTimeSlice, cmPerPixel);
    volumeArr(time) = findVolume(reorientedVentricle, 4, cmPerPixel, d);
end

% Calculating P(t)

pressureArr = calculatePressure(aortaArea, volumeArr, fr);

% Plotting

plotPressures(pressureArr, fr);

% End

disp("END");

