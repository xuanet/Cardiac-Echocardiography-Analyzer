function aa = AorticArea(data, cmPerPixel)


    % Need to find first height slice that clearly shows aorta, LV, and
    % apex


    dimensions = size(data);
    heightSlices = dimensions(2);

    bf = selectSlice(data, heightSlices);

    curSlice = data(:,bf,:);
    extract = squeeze(curSlice);
    figure(1)
    title('Draw Vector');
    imshow(extract', []);
    
%     data = imrotate3(data, 3, [0 0 1]);
%     curSlice = data(:,129,:);
%     extract = squeeze(curSlice);
%     figure(2)
%     imshow(extract', [], 'InitialMagnification', 10000);
    
    disp('Click 3 points in the following order:');
    disp('1. Aortic Valve');
    disp('2. Mitral Valve');
    disp('3. Apex');
    
    [aortaX, aortaY] = ginput(1);
    [mitralX, mitralY] = ginput(1);
    [apexX, apexY] = ginput(1);
    
    aortaVec = [apexX-aortaX, apexY-aortaY];
    mitralVec = [apexX-mitralX, apexY-mitralY];
    
    
    angle = acos(dot(aortaVec, mitralVec)/norm(aortaVec)/norm(mitralVec));
    angleDeg = rad2deg(angle);
    
    data = imrotate3(data, angleDeg, [1 0 0], 'FillValues', 100);
    
    curSlice = data(:,bf,:);
    extract = squeeze(curSlice);
    figure(1)
    title('Rotated angle: 0')
    imshow(extract', []);
    
    angle = 0;

    while true
        choice = questdlg('Select this plane?','Plane Confirmation', 'Yes', '+3', '-1', '-1');
        if strcmp(choice, 'Yes')
            break
        end
        switch choice
            case '+3'
                angle = angle+3;
            case '-1'
                angle = angle-1;
        end
        data2 = imrotate3(data, angle, [0 1 0], 'FillValue', 100);
        curSlice = data2(:,bf,:);
        extract = squeeze(curSlice);
        figure(1)
        imshow(extract', []);
        title("Rotated angle: "+ angle);
    end
    
    disp('Enclose the aorta');
    
    hFH = drawfreehand('Closed', true);
    
    % Get the binary mask of the drawn region
    if exist('hFH', 'var')
        binaryMask = createMask(hFH);
    else
        binaryMask = true(size(midSlice));
    end
        
    % Calculate the area
    areaInPixels = sum(binaryMask(:));
    areaInUnits = areaInPixels * cmPerPixel^2;
    
    %     disp(binaryMask)
    
    area = areaInUnits;
   
    dispArea = ['Aortic area = ', num2str(area), ' cm^2'];
    disp(dispArea);

    aa = area;

end













