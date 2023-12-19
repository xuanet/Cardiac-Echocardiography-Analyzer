clc;
clear variables;
close all;

% About

disp('Aortic Pressure from Echo');
disp('Jose, Kevin, Nidhi');

% Importing echo

heart = resampleDicom('p021_1a.dcm');
fr = 32;
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

fprintf("Now you have a volume array (volumeArr), paste the data into a new csv file (same format as 2.csv). Run pressure.py by changing ln27 to the correct csv file");

% End

disp("END");

