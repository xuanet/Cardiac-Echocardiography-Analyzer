% main.m

clc;
clear variables;
close all;

heart = resampleDicom('05.dcm');

time = 1;

% Call the ReorientVentricle function
[outputVolume] = ReorientVentricle(heart, time);
outputImageSize = size(outputVolume);
disp(outputImageSize);

%displayNewSlices(outputImage);


%drawEndocardialBoundary(imageVolume, outputImage, selectedDimension);
