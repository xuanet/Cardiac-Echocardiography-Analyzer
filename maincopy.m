% main.m

clc;
clear variables;
close all;

heart = resampleDicom('05.dcm');

time = 1;

% disp(size(heart))


% Reorient the ventricle with respct to the anatomy of interest (i.e., the
% long axis
outputVolume = ReorientVentricleCopy(heart, time);


% 
findVolume(outputVolume,4);