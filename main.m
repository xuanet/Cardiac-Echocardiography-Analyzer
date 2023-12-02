% main.m

clc;
clear variables;
close all;

heart = resampleDicom('05.dcm');
time = 5;


a = AorticAreaCopy(heart, time);

disp(a)

% Reorient the ventricle with respct to the anatomy of interest (i.e., the
% long axis
[outputVolume, selectedDimension] = ReorientVentricle(heart, time);

v = findVolume(outputVolume, 4, heart.depthspan/heart.depth, selectedDimension);

disp(v)