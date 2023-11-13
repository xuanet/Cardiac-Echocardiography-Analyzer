
function volume = findVolume(heart, numSlice);

    v = findVolume2(heart, numSlice);

    for i = 1:numSlice
        
        currentSlice = v(:,:,i);
        figure(numSlice*i)
        imshow(currentSlice, []);
        title(num2str(i));

        % Create a binary mask from the drawn freehand region
        freehandROI = drawfreehand('Closed', true);
        
        % Create a binary mask from the drawn region
        binaryMask = createMask(freehandROI);
        
        % Calculate the number of pixels within the region
        numPixels = sum(binaryMask(:));
        
        % Display the number of pixels
        disp(['Number of pixels in the region: ', num2str(numPixels)]);
        
%         area = pixels2area(numPixels, thickness);
%         
%         disp(['area in cm^2: ', num2str(area)])
% 
%         areas(i) = area;

        pause(1);
    end

    volume = num2str(pixels);
end    

function v = findVolume2(heart, numSlice)

    currentHeart = heart;

    % heart is 3D image with long axis aligned
    % numSlices is how many long axis slices used for volume calculation

    % Get size of heart:
    [m, n, p] = size(heart);
    centerW = floor(m/2);

    disp CenterW
    disp(centerW)



    % Calculating rotation angle
    angle = 180/numSlice;

    % Creating array to store long axis slices
    widthSlices = zeros(p, n, numSlice);
%     disp HERE
%     disp(size(widthSlices))
% 
%     disp widthArrayD
%     disp(size(widthSlices))

    disp(widthSlices)

    % Assigning middle index of width

    rvecDepth = [0 0 1];

    % Adding slices to widthSlices
    for i = 1:numSlice
        currentSlice = currentHeart(centerW,:,:);

        currentSlice = squeeze(currentSlice);
        currentSlice = currentSlice';

%         figure(i)
%         imshow(currentSlice, [])

%         disp currentSliceDimensions
        disp(size(currentSlice))
%         disp widthArrayDimensions
%         disp(size(widthSlices(i)));
        widthSlices(:,:,i) = currentSlice;
% 
%         % Rotate heart by angle to get next slice
        currentHeart = imrotate3(heart, angle*i, rvecDepth, "linear", "crop");
    end
    
    v = widthSlices;
end


