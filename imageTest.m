clc
clear variables
close all

currentVersion = "10/27/23";


heart = resampleDicom('05.dcm');

% centerH = floor(heart.height/2);
% centerW = floor(heart.width/2);
% centerD = floor(heart.depth/2);
% 
% extractW = heart.data(centerW,:,:,1);
% extractH = heart.data(:,centerH,:,1);
% extractD = heart.data(:,:,centerD,1);

% widthSlice(heart, 50, 200);


extractW = heart.data(150,:,:,1);
imgW = squeeze(extractW);

% dimension = "width";
% 
figure(1)
imshow(imgW',[]);
% 
% 
% h = drawfreehand('Closed', true);
% wait(h);

v = findVolume(heart.data, 90, 180, 5, heart.widthspan/heart.width);

disp(v)


%find(bitmask to find wedge radius)


function volume = findVolume(data, low, high, increment, thickness)
    figure(1)

    set(gcf, 'Position', get(0, 'Screensize'));


    numSlices = fix((high-low)/increment);
    areas = zeros(1,numSlices);

    for i = 1:numSlices
        sliceIndex = low+(i-1)*increment;
        extractW = data(sliceIndex, :,:,1);
        imgW = squeeze(extractW);
%         figure(1)
        imshow(imgW', []);
        title(num2str(sliceIndex));

        % Create a binary mask from the drawn freehand region
        freehandROI = drawfreehand('Closed', true);
        
        % Create a binary mask from the drawn region
        binaryMask = createMask(freehandROI);
        
        % Calculate the number of pixels within the region
        numPixels = sum(binaryMask(:));
        
        % Display the number of pixels
        disp(['Number of pixels in the region: ', num2str(numPixels)]);
        
        area = pixels2area(numPixels, thickness);
        
        disp(['area in cm^2: ', num2str(area)])

        areas(i) = area;

        pause(1);
    end    

    % total volume
    % thickness is really thickness per index, but each slice corresponds
    % to increment*index
    
    volume = sum(areas)*increment*thickness;



end

function totalArea = pixels2area(numPixels, thickness)

    % cm/pixel, small number

    totalArea = thickness^2*numPixels;


end







% imgW = squeeze(extractW);
% imgH = squeeze(extractH);
% imgD = squeeze(extractD); 
% 
% d = floor(heart.depth);
% w = floor(heart.width);
% h = floor(heart.height);
% 
% 
% widthdistance = heart.widthspan; %cm
% heightdistance = heart.heightspan; %cm
% depthdistance = heart.depthspan; %cm
% 
% 
% h2 = figure(2);
% % width
% sp2_1 = subplot(2, 2, 1);
% imshow(imgW', []);
% title('Width');
% line([centerH centerH], [1 d],'Color','red','LineWidth',2) 
% line([1 h], [centerD centerD],'Color','green','LineWidth',2)
% addborder(1, d, h, 1, 'blue');