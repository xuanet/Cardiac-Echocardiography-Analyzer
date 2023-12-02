function area = AorticAreaCopy(heart, time)
    
    data = heart.data(:,:,:,time);
    
    valveCenters = []; % Initialize an array to store the centers
    pointsSelected = 0; % Counter for the number of points selected
    
    for frame = 50:210
        if pointsSelected >= 2 % Break the loop if two points have already been selected
            break;
        end

        extractD = data(:,:,frame);
        imgD = squeeze(extractD);
        figure(1)
        imshow(imgD', []);
        title(num2str(frame));
        
        choice = questdlg('Is the aortic in view in this slice?', 'Aorta View Confirmation', 'Yes', 'No', 'No');
        if strcmp(choice, 'Yes')
            disp('Click the center of the aortic valve');
            [x, y] = ginput(1); % Get one point
            valveCenters = [valveCenters; x, y, frame]; % Store the x, y, and frame number
            pointsSelected = pointsSelected + 1; % Increment the point counter
        end
    end
    
    disp(valveCenters)
    % Check if two points have been selected
    if size(valveCenters, 1) >= 2
        % Use the first and second points for calculations
        xTop = valveCenters(1, 1);
        yTop = valveCenters(1, 2);
        zTop = valveCenters(1, 3);
        xBottom = valveCenters(2, 1);
        yBottom = valveCenters(2, 2);
        zBottom = valveCenters(2, 3);

        % Calculate the rotation angle
        %rvec = [0, 0, 1];
        %Angle = atan((abs(xTop-xBottom))/(abs(zTop-zBottom))); 
        %AngleDeg = rad2deg(Angle);
        %ccwangle = AngleDeg;


         % Define the vectors
        lineVector = [xBottom - xTop, yBottom - yTop, zBottom - zTop]; % Vector of the line connecting the two points
        verticalVector = [0, 0, 1]; % Vector representing the vertical line

        % Normalize the vectors
        lineVectorNorm = lineVector / norm(lineVector);
        verticalVectorNorm = verticalVector / norm(verticalVector);

        % Calculate the angle using the dot product
        dotProd = dot(lineVectorNorm, verticalVectorNorm);
        angleRad = acos(dotProd); % Angle in radians
        angleDeg = rad2deg(angleRad); % Convert angle to degrees

        % Calculating rvec
        matrix = [yBottom - yTop, zBottom - zTop; 0, 1];
        p = inv(matrix)*[xTop - xBottom; 0];

        rvec = [1 p(1) p(2)];


        
        % Apply rotation to the data
        rotatedData = imrotate3(data, angleDeg, rvec, 'linear', 'crop', 'FillValues', 100);

        % Calculate the midpoint Z slice of the rotated data
        midZ = floor((zTop + zBottom)/2);
        midSlice = squeeze(rotatedData(:,:,midZ));

        % Display the midpoint Z slice
        figure(2)
        imshow(midSlice', []);
        title('Midpoint Depth Slice of Rotated Data');
    else
        error('Not enough points selected for rotation.');
    end

    hFH = drawfreehand('Closed', true);

    % Get the binary mask of the drawn region
    if exist('hFH', 'var')
        binaryMask = createMask(hFH);
    else
        binaryMask = true(size(midSlice));
    end

    % Calculate pixel spacing based on provided dimensions
    pixelSpacingH = heart.heightspan / heart.height_padded;
    pixelSpacingD = heart.depthspan / heart.depth_padded;
    pixelSpacingW = heart.widthspan / heart.width_padded;


    % Since we're working with a 2D slice, choose appropriate pixel spacing
    pixelSpacing = [pixelSpacingW, pixelSpacingH];
        
    % Calculate the area
    areaInPixels = sum(binaryMask(:));
    areaInUnits = areaInPixels * prod(pixelSpacing);

    disp(binaryMask)

    area = areaInUnits;
end
