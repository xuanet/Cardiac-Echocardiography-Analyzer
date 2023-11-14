% main.m

clc;
clear variables;
close all;

heart = resampleDicom('05.dcm');

% We need to see how much real distance each pixel represents. Luckily, it
% 1 pixel represent the same distance in each direction
cmPerPixel = heart.depthspan/heart.depth;

time = 5;


% Reorient the ventricle with respct to the anatomy of interest (i.e., the
% long axis
outputVolume = ReorientVentricleCopy(heart, time);
numSlice = 6;

volume = findVolume(outputVolume,numSlice,cmPerPixel);