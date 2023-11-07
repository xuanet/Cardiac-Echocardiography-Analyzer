% main.m

clc;
clear variables;
close all;

heart = resampleDicom('05.dcm');

% Call the ReorientVentricle function
%[outputVolume, selectedDimension] = ReorientVentricle(heart);
[outputVolume, selectedDimension] = ReorientVentricleCopy(heart);
outputImageSize = size(outputVolume);
disp(outputImageSize);

displayNewSlices(outputImage);


if ~isempty(outputImage)
    % Call the drawEndocardialBoundary function to draw the endocardial boundary
    drawEndocardialBoundary(imageVolume, outputImage, selectedDimension);
else
    disp('ReorientVentricle function did not return an image.');
end