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
imshow(imgW',[])


% Create a binary mask from the drawn freehand region
freehandROI = drawfreehand('Closed', true);
[x,y]=ginput(2);

col = round(x(1));
topRow = round(y(1));
botRow = round(y(2));

radiusLeft = zeros(botRow-topRow,1);
radiusRight = zeros(botRow-topRow,1);




% Create a binary mask from the drawn region
binaryMask = createMask(freehandROI);

for row = topRow:botRow
    currentRow = binaryMask(row,:);
    leftArray = currentRow(1:col-1);
    rightArray = currentRow(col+1:end);

    first = sum(leftArray);
    second = sum(rightArray);

    radiusLeft(row-topRow+1) = first;
    radiusRight(row-topRow+1) = second;

    disp(sum(currentRow));
    disp(first+second);
    
end


