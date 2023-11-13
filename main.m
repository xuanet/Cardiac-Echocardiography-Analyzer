% main.m

clc;
clear variables;
close all;

heart = resampleDicom('05.dcm');

time = 5;

% Reorient the ventricle with respct to the anatomy of interest (i.e., the
% long axis
[outputVolume] = ReorientVentricle(heart, time);



%drawEndocardialBoundary(outputVolume);