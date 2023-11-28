function [outputVolume, selectedDimension] = ReorientVentricle(heart, time)
    
    
    % Created by Jose on 10/26/23
    % Updated by Kevin on 10/27/23
    % Updated by Jose on 10/27/23
    % Updated by Jose on 10/30/23
    % Updated by Jose on 10/31/23
    % Updated by Jose on 11/7/23
    % Final Update by Jose on 11/12/23

    currentVersion = "10/26/23";

    centerH = floor(heart.height/2);
    centerW = floor(heart.width/2);
    centerD = floor(heart.depth/2);
    
    extractW = heart.data(centerW,:,:,time);
    extractH = heart.data(:,centerH,:,time);
    extractD = heart.data(:,:,centerD,time);

    imgW = squeeze(extractW);
    imgH = squeeze(extractH);
    imgD = squeeze(extractD); 
    
    d = floor(heart.depth);
    w = floor(heart.width);
    h = floor(heart.height);

    widthdistance = heart.widthspan; %cm
    heightdistance = heart.heightspan; %cm
    depthdistance = heart.depthspan; %cm
    
    figure(1);
    % width
    sp2_1 = subplot(2, 2, 1);
    imshow(imgW', []);
    title('Width');
    line([centerH centerH], [1 d],'Color','red','LineWidth',2) 
    line([1 h], [centerD centerD],'Color','green','LineWidth',2)
    addborder(1, d, h, 1, 'blue');
    
    % height
    sp2_2 = subplot(2, 2, 2);
    imshow(imgH', []);
    title('Height');
    line([centerW centerW], [1 d],'Color','blue','LineWidth',2) 
    line([1 w], [centerD centerD],'Color','green','LineWidth',2)
    addborder(1, d, w, 1, 'red');
    
    
    % depth
    sp2_3 = subplot(2, 2, 3);
    imshow(imgD', []);
    title('Depth');
    line([centerW centerW], [1 h],'Color','blue','LineWidth',2) 
    line([1 w], [centerH centerH],'Color','red','LineWidth',2)
    addborder(1, h, w, 1, 'green');
    
    
    [x, y] = ginput(2);
    
    % Identify the subplot user clicked on
    ax = gca; % Get the current axes handle
    if ax == sp2_1
        dimension = 'W';
    elseif ax == sp2_2
        dimension = 'H';
    elseif ax == sp2_3
        dimension = 'D';
        disp 'You have selected the Depth image, which has incorrect rotations as of' 
        disp(currentVersion);
    else
        error('Unexpected axes handle.');
    end
    
    linemaker(x(1), y(1), x(2), y(2));
    
    midpoint = midptofline(x(1), y(1), x(2), y(2));
    lengthofline = distanceinpixels(x(1), y(1), x(2), y(2));


    % Calculate pixels per centimeter ratio
    switch dimension
        case 'W'
            pixelsPerCm = w / widthdistance;
        case 'H'
            pixelsPerCm = h / heightdistance;
        case 'D'
            pixelsPerCm = d / depthdistance;
        otherwise
            error('Unexpected dimension.');
    end

    % Calculate the length of the line in centimeters
    lengthOfLineCm = lengthofline / pixelsPerCm;

% Display the length of the line in centimeters
fprintf('Distance from base to apex is %.2f cm.\n', lengthOfLineCm);
    
    centerX = midpoint(1);
    centerY = midpoint(2);
    radiusofcircle = lengthofline/8;
    circlemakerforlines(centerX, centerY, radiusofcircle);


    
    % Default translations
    d_D = 0;
    d_H = 0;
    d_W = 0;
    
    % Compute translations based on selected dimension
    switch dimension
        case 'W'
            d_D = 2 * (heart.depth/2 - centerY);
            d_W = 2 * (heart.width/2 - centerX);
            d_H = 0;
        case 'H'
            d_D = 2 * (heart.depth/2 - centerY); 
            d_H = 2 * (heart.width/2 - centerX); 
            d_W = 0; 
        case 'D'
            d_H = 2 * (heart.depth/2 - centerY);
            d_W = 2 * (heart.width/2 - centerX);
            d_D = 0; 
    end
    
    % Compute the translated volume
    vol_transfull = imtranslate(heart.data(:,:,:,time), [d_W d_H d_D], 'OutputView', 'full', 'FillValues', 128);
    
    % Extract the relevant slice based on the selected dimension
    switch dimension
        case 'W'
            extract_transfull = vol_transfull(centerW, :, :);
            originalTitle = get(get(sp2_1, 'Title'), 'String');
        case 'H'
            extract_transfull = vol_transfull(:, centerH, :);
            originalTitle = get(get(sp2_2, 'Title'), 'String');
        case 'D'
            extract_transfull = vol_transfull(:, :, centerD);
            originalTitle = get(get(sp2_3, 'Title'), 'String');
    end
    
    img_transfull = squeeze(extract_transfull);
    figure(1)
    imshow(img_transfull', []);
    title(originalTitle); % Set the original title
    
    [newrows, newcols, ~] = size(img_transfull');
    newcenter_y = newrows / 2;
    newcenter_x = newcols / 2;
    
    circlemakerforlines(newcenter_x, newcenter_y, radiusofcircle);
    
    
    
    
    % Calculate the angle with the vertical axis
    deltaY = abs(y(2) - y(1));
    deltaX = abs(x(1) - x(2));
    angle = atan(deltaY/deltaX); 
    angleDeg = rad2deg(angle);
    ccwangle = 90 - angleDeg;
    
    % setting the rotation vector
    rvecWidth = [0 -1 0];
    rvecHeight = [1 0 0];
    rvecDepth = [0 0 -1];
    
    rvec = [0 0 0];
    
    switch dimension
        case 'W'
            rvec = rvecWidth;
        case 'H'
            rvec = rvecHeight;   
        case 'D'
            rvec = rvecDepth;
    end
    
    
    vol_transfull_rotated = imrotate3(vol_transfull, ccwangle, rvec, 'FillValues', 100);
    
    
    % Extract the relevant slice based on the selected dimension
    switch dimension
        case 'W'
            extract_transfull = vol_transfull_rotated(centerW, :, :);
            originalTitle = get(get(sp2_1, 'Title'), 'String');
        case 'H'
            extract_transfull = vol_transfull_rotated(:, centerH, :);
            originalTitle = get(get(sp2_2, 'Title'), 'String');
        case 'D'
            extract_transfull = vol_transfull_rotated(:, :, centerD);
            originalTitle = get(get(sp2_3, 'Title'), 'String');
    end
    
    img_transfull = squeeze(extract_transfull);
    figure(1)
    imshow(img_transfull', []);
    title(originalTitle); % Set the original title
    
    [newrows, newcols, ~] = size(img_transfull');
    newcenter_y = newrows / 2;
    newcenter_x = newcols / 2;
    
    circlemakerforlines(newcenter_x, newcenter_y, radiusofcircle);
    
    
    % Reorient based on the translations performed earlier
    switch dimension
        case 'W'
            x1 = newcenter_x - w/2 + d_W/2; 
            y1 = newcenter_y - d/2 + d_D/2;
            cropRect = [x1, y1, h-1, d-1];
            % Crop the image
            croppedImage = imcrop(img_transfull', cropRect);
    
            % Display the cropped image
            figure(1)
            imshow(croppedImage, []);
            title('Reoriented Width');
            dimension = 'W';

        case 'H'
            x1 = newcenter_x - h/2 + d_H/2; 
            y1 = newcenter_y - d/2 + d_D/2;
            cropRect = [x1, y1, w-1, d-1];
            % Crop the image
            croppedImage = imcrop(img_transfull', cropRect);
    
            % Display the cropped image
            figure(1)
            imshow(croppedImage, []);
            title('Reoriented Height');
            dimension = 'H';
        
        case 'D'
            x1 = newcenter_x - w/2 + d_W/2; 
            y1 = newcenter_y - h/2 + d_H/2;
            cropRect = [x1, y1, w-1, h-1];
            % Crop the image
            croppedImage = imcrop(img_transfull', cropRect);
    
            % Display the cropped image
            figure(1)
            imshow(croppedImage, []);
            title('Reoriented Depth');
            dimension = 'd';
    end



    [newCropHeight, newCropWidth] = size(croppedImage);
    
    % Preallocate the array for the cropped volume
    % The depth of the volume will depend on the selected dimension
    switch dimension
        case 'W'
            croppedVolume = zeros(newCropHeight, newCropWidth, size(vol_transfull_rotated, 1)); 
        case 'H'
            croppedVolume = zeros(newCropHeight, newCropWidth, size(vol_transfull_rotated, 2)); 
        case 'D'
            croppedVolume = zeros(newCropHeight, newCropWidth, size(vol_transfull_rotated, 3)); 
    end



    switch dimension
        case 'W'
            % Loop through each slice depending on the selected dimension
            for i = 1:size(vol_transfull_rotated, 1)

                slice = squeeze(vol_transfull_rotated(i, :, :));
                x1 = newcenter_x - w/2 + d_W/2; 
                y1 = newcenter_y - d/2 + d_D/2; 
                cropRect = [x1, y1, h-1, d-1]; 
                
                % Crop the slice to match the display orientation
                croppedSlice = imcrop(slice', cropRect);
                
                % Assign the cropped slice into the corresponding position of the 3D volume
                croppedVolume(:, :, i) = croppedSlice;
            end
            semifinaltitle = 'Reoriented Width';
            finaltitle = 'Final Reoriented Width';

        case 'H'
            % Loop through each slice depending on the selected dimension
            for i = 1:size(vol_transfull_rotated, 2)

                slice = squeeze(vol_transfull_rotated(:, i, :));
                x1 = newcenter_x - h/2 + d_H/2; 
                y1 = newcenter_y - d/2 + d_D/2; 
                cropRect = [x1, y1, w-1, d-1]; 
                
                % Crop the slice to match the display orientation
                croppedSlice = imcrop(slice', cropRect);

                croppedVolume(:, :, i) = croppedSlice;
            end
            semifinaltitle = 'Reoriented Height';
            finaltitle = 'Final Reoriented Height';

        case 'D'
            % Loop through each slice depending on the selected dimension
            for i = 1:size(vol_transfull_rotated, 3)

                slice = squeeze(vol_transfull_rotated(:, :, i));
                x1 = newcenter_x - w/2 + d_W/2; 
                y1 = newcenter_y - h/2 + d_H/2; 
                cropRect = [x1, y1, w-1, h-1]; 
                
                % Crop the slice to match the display orientation
                croppedSlice = imcrop(slice', cropRect);
                
                % Assign the cropped slice into the corresponding position of the 3D volume
                croppedVolume(:, :, i) = croppedSlice;
            end
            semifinaltitle = 'Reoriented Depth';
            finaltitle = 'Final Reoriented Depth';
    end

    
    % reordering the dimensions in the original order
    switch dimension
        case 'W'
            newOrder = [3, 2, 1];
            SemiFinalcroppedVolume = permute(croppedVolume, newOrder);
            new_center = floor(size(SemiFinalcroppedVolume, 1)/2);
            new_extract = SemiFinalcroppedVolume(new_center,:,:);
    
        case 'H'
            newOrder = [2, 3, 1];
            SemiFinalcroppedVolume = permute(croppedVolume, newOrder);
            new_center = floor(size(SemiFinalcroppedVolume, 2)/2);
            new_extract = SemiFinalcroppedVolume(:,new_center,:);
    end
    
    semifinalimg = squeeze(new_extract);

    figure(1)
    imshow(semifinalimg', []);
    title(semifinaltitle); % Set the final title
    

    % Determine the slice positions
    topDepth = floor(size(SemiFinalcroppedVolume, 3) / 5); % Quarter of the way from the top of depth
    bottomDepth = floor(size(SemiFinalcroppedVolume, 3) / 2.6); % Third of the way through the depth
    
    % Extract the top quarter depth slice
    topSlice = squeeze(SemiFinalcroppedVolume(:,:,topDepth));
    % Extract the bottom quarter depth slice
    bottomSlice = squeeze(SemiFinalcroppedVolume(:,:,bottomDepth)); 
    
    % Collect user input on both slices
    figure(2);
    subplot(2, 1, 1);
    imshow(topSlice', []);
    title('Top Depth Slice');
    [xTop, yTop] = ginput(1);
    
    subplot(2, 1, 2);
    imshow(bottomSlice', []);
    title('Bottom Depth Slice');
    [xBottom, yBottom] = ginput(1);
    
    % Convert the 2D points to 3D coordinates
    zTop = topDepth;
    zBottom = bottomDepth;
    
    switch dimension
        case 'W'
         % Define the vectors
        lineVector = [xBottom - xTop, yBottom - yTop, zBottom - zTop]; % Vector of the line connecting the two points
        verticalVector = [0, 0, 1]; % Vector representing the vertical line

        % Normalize the vectors
        lineVectorNorm = lineVector / norm(lineVector);
        verticalVectorNorm = verticalVector / norm(verticalVector);

        % Calculate the angle using the dot product
        dotProd = dot(lineVectorNorm, verticalVectorNorm);
        angleRad = acos(dotProd); % Angle in radians
        Secondccwangle = rad2deg(angleRad); % Convert angle to degrees

        % Calculating rvec
        matrix = [yBottom - yTop, zBottom - zTop; 0, 1];
        p = inv(matrix)*[xTop - xBottom; 0];

        Secondrvec = [1 p(1) p(2)];
            
        case 'H'
            Secondrvec = [0, -1, 0];
            SecondAngle = atan((abs(yTop-yBottom))/(abs(zTop-zBottom))); 
            SecondAngleDeg = rad2deg(SecondAngle);
            Secondccwangle = SecondAngleDeg;
    end
    
    % Perform the rotation
    FinaloutputVolume = imrotate3(SemiFinalcroppedVolume, Secondccwangle, Secondrvec, 'linear', 'crop', 'FillValues', 100);

    switch dimension
        case 'W'
            final_center = floor(size(FinaloutputVolume, 1)/2);
            final_extract = FinaloutputVolume(final_center,:,:);
    
        case 'H'
            final_center = floor(size(FinaloutputVolume, 2)/2);
            final_extract = FinaloutputVolume(:,final_center,:);
    end
    
    % Display final image on figure 1
    finalimg = squeeze(final_extract);
    figure(1)
    imshow(finalimg', []);
    title(finaltitle); 

    outputVolume = FinaloutputVolume; 
    selectedDimension = dimension;
end 