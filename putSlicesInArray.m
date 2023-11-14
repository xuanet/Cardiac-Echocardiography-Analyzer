function v = putSlicesInArray(heart, numSlice, selectedDimension)

    currentHeart = heart;
    % heart is 3D image with long axis aligned
    % numSlices is how many long axis slices used for volume calculation
    if selectedDimension == 'W'
            
        % Get size of heart:
        [w, h, d] = size(heart);
        centerW = floor(w/2);
    
    
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