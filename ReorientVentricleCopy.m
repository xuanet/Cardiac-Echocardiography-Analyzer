function [outputVolume] = ReorientVentricleCopy(heart, time)
    
    
    % Created by Jose on 10/26/23
    % Updated by Kevin on 10/27/23
    % Updated by Jose on 10/27/23
    % Updated by Jose on 10/30/23
    % Updated by Jose on 10/31/23
    % Updated by Jose on 11/7/23

    currentVersion = "10/26/23";

    data = heart.data(:,:,:,time);
    
    centerW = floor(heart.width/2);
    centerH = floor(heart.height/2);
    centerD = floor(heart.depth/2);

    extractW = data(centerW,:,:);
    imgW = squeeze(extractW);
    
    w = floor(heart.width);
    widthdistance = heart.widthspan; %cm

    
    figure(1);
    % width
    imshow(imgW', []);
    title('Original Width');
    
    [x, y] = ginput(2);
    
    % Identify the subplot user clicked on
    
    linemaker(x(1), y(1), x(2), y(2));
    midpoint = midptofline(x(1), y(1), x(2), y(2));
    lengthofline = distanceinpixels(x(1), y(1), x(2), y(2));


    % Calculate pixels per centimeter ratio
    pixelsPerCm = w / widthdistance;

    % Calculate the length of the line in centimeters
    lengthOfLineCm = lengthofline / pixelsPerCm;

    % Display the length of the line in centimeters
    fprintf('Distance from base to apex is %.2f cm.\n', lengthOfLineCm);
    
    centerX = midpoint(1);
    centerY = midpoint(2);
    radiusofcircle = lengthofline/8;
    circlemakerforlines(centerX, centerY, radiusofcircle);



    
    d_W = 2 * (heart.width/2 - centerX);

    % Compute the translated volume
    vol_transfull = imtranslate(data, [d_W 0 0], 'OutputView', 'full', 'FillValues', 128);
    
    % Extract the relevant slice based on the selected dimension
    extract_transfull = vol_transfull(centerW, :, :);

    
    img_transfull = squeeze(extract_transfull);
    figure(2)
    imshow(img_transfull', []);
    title("Translated Width"); % Set the original title
    
    [newrows, newcols, ~] = size(img_transfull');
    newcenter_y = newrows / 2;
    newcenter_x = newcols / 2;
    
    circlemakerforlines(newcenter_x, newcenter_y, radiusofcircle);
    
    
    
    
    % Calculate the angle with the vertical axis
    deltaY = y(2) - y(1);
    deltaX = x(1) - x(2);
    angle = atan(deltaY/deltaX); 
    angleDeg = rad2deg(angle);
    ccwangle = 90 - angleDeg;
    
    % setting the rotation vector
    rvecWidth = [0 -1 0];
    
    
    vol_transfull_rotated = imrotate3(vol_transfull, ccwangle, rvecWidth, "linear", "crop");
    
    
    % Extract the relevant slice based on the selected dimension
    extract_transfull = vol_transfull_rotated(centerW, :, :);
    
    img_transfull = squeeze(extract_transfull);
    figure(3)
    imshow(img_transfull', []);
    title("Rotated Width"); % Set the original title
    
    [newrows, newcols, ~] = size(img_transfull');
    newcenter_y = newrows / 2;
    newcenter_x = newcols / 2;
    
    circlemakerforlines(newcenter_x, newcenter_y, radiusofcircle);
    
    

%     % Reorient based on the translations performed earlier
%     x1 = newcenter_x - w/2 + d_W/2; 
%     y1 = newcenter_y - d/2 + d_D/2;
%     cropRect = [x1, y1, h-1, d-1];
%     % Crop the image
%     croppedImage = imcrop(img_transfull', cropRect);
%     
%     % Display the cropped image
%     figure(4)
%     imshow(croppedImage, []);
%     title('Cropped Width');
%     dimension = 'W';
% 
%        
% 
%     [newCropHeight, newCropWidth] = size(croppedImage);
    
    % Preallocate the array for the cropped volume
    % The depth of the volume will depend on the selected dimension

%     croppedVolume = zeros(newCropHeight, newCropWidth, size(vol_transfull_rotated, 1), time);



%     switch dimension
%         case 'W'
%             % Loop through each slice depending on the selected dimension
%             for i = 1:size(vol_transfull_rotated, 1)
% 
%                 slice = squeeze(vol_transfull_rotated(i, :, :, time));
%                 x1 = newcenter_x - w/2 + d_W/2; 
%                 y1 = newcenter_y - d/2 + d_D/2; 
%                 cropRect = [x1, y1, h-1, d-1]; 
%                 
%                 % Crop the slice to match the display orientation
%                 croppedSlice = imcrop(slice', cropRect);
%                 
%                 % Assign the cropped slice into the corresponding position of the 3D volume
%                 croppedVolume(:, :, i) = croppedSlice;
%             end
%             finaltitle = 'Reoriented Width';
% 
%         case 'H'
%             % Loop through each slice depending on the selected dimension
%             for i = 1:size(vol_transfull_rotated, 2)
% 
%                 slice = squeeze(vol_transfull_rotated(:, i, :, time));
%                 x1 = newcenter_x - h/2 + d_H/2; 
%                 y1 = newcenter_y - d/2 + d_D/2; 
%                 cropRect = [x1, y1, w-1, d-1]; 
%                 
%                 % Crop the slice to match the display orientation
%                 croppedSlice = imcrop(slice', cropRect);
% 
%                 croppedVolume(:, :, i, time) = croppedSlice;
%             end
%             finaltitle = 'Reoriented Height';
% 
%         case 'D'
%             % Loop through each slice depending on the selected dimension
%             for i = 1:size(vol_transfull_rotated, 3)
% 
%                 slice = squeeze(vol_transfull_rotated(:, :, i, time));
%                 x1 =newcenter_x - w/2 + d_W/2; 
%                 y1 = newcenter_y - h/2 + d_H/2; 
%                 cropRect = [x1, y1, w-1, h-1]; 
%                 
%                 % Crop the slice to match the display orientation
%                 croppedSlice = imcrop(slice', cropRect);
%                 
%                 % Assign the cropped slice into the corresponding position of the 3D volume
%                 croppedVolume(:, :, i, time) = croppedSlice;
%             end
%             finaltitle = 'Reoriented Depth';
%     end
%     
%     disp(size(croppedVolume, 1));
%     disp(size(croppedVolume, 2));
%     disp(size(croppedVolume, 3));
% 
%     new_center = floor(size(croppedVolume, 3)/2);
%     
%     new_extract = croppedVolume(:,:,new_center,1);
% 
%     finalimg = squeeze(new_extract);
% 
%     figure(1)
%     imshow(finalimg, []);
%     title(finaltitle); % Set the final title

    outputVolume = vol_transfull_rotated; % This is now a 3D volume
end 