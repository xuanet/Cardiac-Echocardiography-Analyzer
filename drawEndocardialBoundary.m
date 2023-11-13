function drawEndocardialBoundary(imageVolume, heart, dimension)
    numSlices = heart.dimension; % Total number of slices in the given dimension
    totalSpanCm = dimension.span; % Total span across slices in cm

    % Calculate spacing between slices
    if numSlices > 1
        sliceSpacing = totalSpanCm / (numSlices - 1);
    else
        sliceSpacing = totalSpanCm;
    end

    desiredNumBoundaries = 20;
    sliceSkip = max(floor(numSlices / desiredNumBoundaries), 1);
    volumes = zeros(1, ceil(numSlices / sliceSkip));  % Preallocate volume array

    sliceIndices = 1:sliceSkip:numSlices;  % Indices of slices to draw on

    for i = 1:length(sliceIndices)
        sliceNum = sliceIndices(i);
        currentSlice = imageVolume(:,:,sliceNum);

        figure;
        imshow(currentSlice, []);
        title(['Slice ', num2str(sliceNum), ' (Dimension: ', dimension.name, ')']);

        % Initialize total area for the current slice
        totalEnclosedAreaCm2 = 0;
        
        % User draws multiple boundaries
        option = 'Yes';
        while strcmp(option, 'Yes')
            h = drawfreehand('Closed', true);
            wait(h);
        
            % Calculate area
            enclosedAreaPixels = polyarea(h.Position(:,1), h.Position(:,2));
            enclosedAreaCm2 = enclosedAreaPixels * (sliceSpacing^2);  % Convert pixel area to cm^2
            totalEnclosedAreaCm2 = totalEnclosedAreaCm2 + enclosedAreaCm2;
        
            option = questdlg('Draw another boundary on this slice?', 'Multiple Boundaries', 'Yes', 'No', 'Yes');
        end

        % Store total area for the current slice
        volumes(i) = totalEnclosedAreaCm2;

        fprintf('Total area of slice %d in %s dimension: %.2f cm^2\n', sliceNum, dimension.name, totalEnclosedAreaCm2);

        % Option to continue or end
        if i < length(sliceIndices)
            continueOption = questdlg('Continue to the next slice?', 'Continue', 'Yes', 'End', 'Yes');
            if strcmp(continueOption, 'End')
                break;
            end
        end

        close; % Close the current figure
    end

    % Calculate total volume (assuming the volume between each slice is simply the area of the slice times the slice thickness)
    totalVolumeCm3 = sum(volumes) * sliceSpacing;
    fprintf('Total enclosed volume: %.2f cm^3\n', totalVolumeCm3);
end
