function results = calculatePressure(aorticArea, volumes, frameRate)
    %Inputs args are: area in cm^2, volume is mL and frame rate in
    %1/seconds
    %Output is in mmHg
    density = 1.1; %g/mL

    if nargin < 3
        error('Not enough input arguments.');
    end

    numVolumes = numel(volumes);

    if numVolumes < 3
        error('Need at least three volumes to proceed.');
    end
    results = zeros(1, numVolumes - 2);
    for i = 1:(numVolumes - 2)
        v1 = volumes(i);
        v2 = volumes(i+1);
        v3 = volumes(i+2);
        result = density * (v3 - v2) * ((v3 - v2) - (v2 - v1)) * (frameRate^2) / (aorticArea^2);
        results(i) = result*10*0.00750062; %results in units of 0.1Pa %result in Pa %result in mmHg
    end
end
