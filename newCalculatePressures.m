function pa = newCalculatePressures(volumeArr, aorticArea, frameRate, majorAxis, minorAxis, density)
    if nargin < 6
        error('Not enough input arguments.');
    end

    deltaT = 1/frameRate;
    fprintf('Time step: %f seconds\n', deltaT);
    LVSurfaceArea = ellipsoidSA(majorAxis, minorAxis);

    numPressures = numel(volumeArr)-1;
    pa = zeros(1, numPressures);

    % Iterating through volumeArr

    for i = 2:numel(volumeArr)
        % Find volume of blood pumped into aorta
        vAorta = volumeArr(i-1)-volumeArr(i);
        pressureInRawUnits = (vAorta^2*density)/(aorticArea*LVSurfaceArea*(deltaT^2));
        pa(i-1) = pressureInRawUnits/10*0.0075;
%         pa(i-1) = vAorta/(aorticArea*deltaT);
    end

end