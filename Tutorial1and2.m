cube = resampleDicom('cube.dcm'); 
heart = resampleDicom('002A.dcm');

centerH = floor(heart.height/2);
centerW = floor(heart.width/2);
centerD = floor(heart.depth/2);

extractW = heart.data(centerW,:,:,1);
extractH = heart.data(:,centerH,:,1);
extractD = heart.data(:,:,centerD,1);

imgW = squeeze(extractW);
imgH = squeeze(extractH);
imgD = squeeze(extractD); 

d = floor(heart.depth);
w = floor(heart.width);
h = floor(heart.height);


widthdistance = heart.widthspan; %cm
heightdistance = heart.heightspan; %cm
depthdistance = heart.depthspan; %cm

dist = index2cm(127.28, d, depthdistance);
disp(dist);

dist2 = points2cm(148, 36, 124, 165, d, depthdistance);
disp(dist2);

%imshow(imgH', [])
figure(1)
imshow(imgD', []);
title('Depth');
line([centerW centerW], [1 h], 'Color', 'blue', 'LineWidth', 2);
line([1 w], [centerH centerH], 'Color', 'red', 'LineWidth', 2);
addborder(1, h, w, 1, 'green');
[x, y] = ginput(1);


h2 = figure(2);
% width
sp2_1 = subplot(2, 2, 1);
imshow(imgW', []);
title('Width');
line([y y], [1 d], 'Color', 'red', 'LineWidth', 2);
line([1 h], [centerD centerD], 'Color', 'green', 'LineWidth', 2);
%line([centerH centerH], [1 d],'Color','red','LineWidth',2) 
%line([1 h], [centerD centerD],'Color','green','LineWidth',2)
addborder(1, d, h, 1, 'blue');

% height
sp2_2 = subplot(2, 2, 2);
imshow(imgH', []);
title('Height');
line([x x], [1 d], 'Color', 'blue', 'LineWidth', 2);
line([1 w], [centerD centerD], 'Color', 'green', 'LineWidth', 2);
%line([centerW centerW], [1 d],'Color','blue','LineWidth',2) 
%line([1 w], [centerD centerD],'Color','green','LineWidth',2)
addborder(1, d, w, 1, 'red');


% depth
sp2_3 = subplot(2, 2, 3);
imshow(imgD', []);
title('Depth');
line([x x], [1 h], 'Color', 'blue', 'LineWidth', 2);
line([1 w], [y y], 'Color', 'red', 'LineWidth', 2);
%line([centerW centerW], [1 h],'Color','blue','LineWidth',2) 
%line([1 w], [centerH centerH],'Color','red','LineWidth',2)
addborder(1, h, w, 1, 'green');


