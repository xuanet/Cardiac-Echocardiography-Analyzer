function volume = findVolumeCopy(heart, numSlice, selectedDimension)

    v = findVolume2(heart, numSlice, selectedDimension);

    for i = 1:numSlice
        
        currentSlice = v(:,:,i);
        figure(numSlice*i+1)
        imshow(currentSlice, []);
        title(num2str(i+1));

        % Create a binary mask from the drawn freehand region
        freehandROI = drawfreehand('Closed', true);
        
        % Create a binary mask from the drawn region
        binaryMask = createMask(freehandROI);
        
        % Calculate the number of pixels within the region
        numPixels = sum(binaryMask(:));
        
        % Display the number of pixels
        disp(['Number of pixels in the region: ', num2str(numPixels)]);
        
        pause(1);
    end

    volume = num2str(numPixels);
end    

function v = findVolume2(heart, numSlice, selectedDimension)

    currentHeart = heart;

    % heart is 3D image with long axis aligned
    % numSlices is how many long axis slices used for volume calculation
    if selectedDimension == 'W'
            
        % Get size of heart:
        [w, h, d] = size(heart);
        centerW = floor(w/2);
    
        disp CenterW
        disp(centerW)
    
    
        % Calculating rotation angle
        angle = 180/numSlice;
    
        % Creating array to store long axis slices
        widthSlices = zeros(d, h, numSlice);
    
        % Assigning middle index of width
        rvec = [0 0 1];
    
        % Adding slices to widthSlices
        for i = 1:numSlice
            currentSlice = currentHeart(centerW,:,:);
            currentSlice = squeeze(currentSlice);
            currentSlice = currentSlice';
            disp(size(currentSlice))
            widthSlices(:,:,i) = currentSlice;
            currentHeart = imrotate3(heart, angle*i, rvec, "linear", "crop");
        end
        v = widthSlices;

    elseif selectedDimension == 'H'
        
        % Get size of heart:
        [w, h, d] = size(heart);
        centerH = floor(h/2);
    
        disp CenterH
        disp(centerH)
        
        % Calculating rotation angle
        angle = 180/numSlice;
    
        % Creating array to store long axis slices
        heightSlices = zeros(d, w, numSlice);
    
        % Assigning middle index of height
        rvec = [0 0 1];
        
        % Adding slices to widthSlices
        for i = 1:numSlice
            currentSlice = currentHeart(:,centerH,:);
            currentSlice = squeeze(currentSlice);
            currentSlice = currentSlice';
            disp(size(currentSlice))
            heightSlices(:,:,i) = currentSlice;
            currentHeart = imrotate3(heart, angle*i, rvec, "linear", "crop");
        end
        v = heightSlices;
    end
end