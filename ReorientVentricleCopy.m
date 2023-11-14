function [outputVolume] = ReorientVentricleCopy(heart, time)
    
    
    % Created by Jose on 10/26/23
    % Updated by Kevin on 10/27/23
    % Updated by Jose on 10/27/23
    % Updated by Jose on 10/30/23
    % Updated by Jose on 10/31/23
    % Updated by Jose on 11/7/23
    % Updated by Kevin on 11/12/23

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
    
    
    vol_transfull_rotated = imrotate3(vol_transfull, ccwangle, rvecWidth, "linear", "crop","FillValues", 100);
    
    
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
    
    

    outputVolume = vol_transfull_rotated; % This is now a 3D volume
end 