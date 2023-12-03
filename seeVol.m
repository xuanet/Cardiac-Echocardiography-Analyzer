close all

heart = resampleDicom('p021_1a.dcm');
% centerW = 100;
rvec = [1 0 0];
data = heart.data(:,:,:,2);

curSlice = data(:,129,:);
extract = squeeze(curSlice);
figure(1)
imshow(extract', []);


data = imrotate3(data, 3, [0 0 1]);
curSlice = data(:,129,:);
extract = squeeze(curSlice);
figure(2)
imshow(extract', []);


[aortaX, aortaY] = ginput(1);
[mitralX, mitralY] = ginput(1);
[apexX, apexY] = ginput(1);

aortaVec = [apexX-aortaX, apexY-aortaY];
mitralVec = [apexX-mitralX, apexY-mitralY];


angle = acos(dot(aortaVec, mitralVec)/norm(aortaVec)/norm(mitralVec));
angleDeg = rad2deg(angle);

data = imrotate3(data, angleDeg, [1 0 0], 'FillValues', 100);

curSlice = data(:,110,:);
extract = squeeze(curSlice);
figure(2)
imshow(extract', []);

for m = 0:5:360
    data2 = imrotate3(data, m, [0 1 0], 'FillValue', 100);
    curSlice = data2(:,129,:);
    extract = squeeze(curSlice);
    figure(2)
    imshow(extract', []);
    choice = questdlg('cup size?', 'Aorta View Confirmation', 'Yes', 'No', 'No');
    if strcmp(choice, 'Yes')
        break
    end
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

%     disp(binaryMask)

    area = areaInUnits;

    disp(area)

   








