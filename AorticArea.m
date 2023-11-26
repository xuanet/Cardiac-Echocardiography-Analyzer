heart = resampleDicom('002A.dcm'); %(Using a pre-aligned set to troubleshoot aorta area and not realignement)
centerH = floor(heart.height / 2);
centerW = floor(heart.width / 2);
centerD = floor(heart.depth / 2);

numTimeFrames = heart.NumVolumes;

% Create a figure
fig = figure;

% Initialize total area
totalArea = 0;

%Select depth slice
currentDepth=150;

    for frame = 1:numTimeFrames
        extractD = heart.data(:, :, currentDepth, frame);
        imgD = squeeze(extractD);
        imshow(imgD', []);
        hFH = drawfreehand;
        
        % Get the binary mask of the drawn region
        if exist('hFH', 'var')
            binaryMask = createMask(hFH);
        else
            binaryMask = true(size(imgD));
        end
        
        % Calculate pixel spacing based on provided dimensions
        pixelSpacingH = heart.heightspan / heart.height_padded;
        pixelSpacingD = heart.depthspan / heart.depth_padded;
        pixelSpacingW = heart.widthspan / heart.width_padded;
        
        % Get pixel spacing information for specific slice
        pixelSpacing = [pixelSpacingW, pixelSpacingH];
        
        % Calculate the area
        areaInPixels = sum(binaryMask(:));
        areaInUnits = areaInPixels * prod(pixelSpacing);
        
        disp(['Area of the drawn region in frame ', num2str(frame), ' at depth ', num2str(currentDepth), ': ', num2str(areaInUnits), ' cm2']);
        
        % Accumulate the area for the current depth
        areaForCurrentDepth = areaForCurrentDepth + areaInUnits;
    end
    
    % Calculate and display the average area for the current depth
    averageAreaForCurrentDepth = areaForCurrentDepth / numTimeFrames;
    disp(['Average area over all frames at depth slice#', num2str(currentDepth), ': ', num2str(averageAreaForCurrentDepth), ' square cm']);
