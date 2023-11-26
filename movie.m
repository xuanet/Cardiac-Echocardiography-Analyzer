close all

heart = resampleDicom('002A.dcm');
centerW = floor(heart.width/2);
% centerW = 100;
rvec = [1 0 0];
data = heart.data(:,:,:,1);


% for frame = 140:190
% %         data = imrotate3(data, angle, rvec, "linear", "crop");
%     slice = data(:,:,frame);
% %         extractW = data(centerW,:,:);
%     imgW = squeeze(slice);
%     figure(1)
%     imshow(imgW', []);
%     title(num2str(frame));
%     pause(0.2)
% %         prompt = inputdlg('Next?');  
% end

slice = data(:,:,170);
imgW = squeeze(slice);
figure(1)
imshow(imgW', []);
[x,y] = ginput(2);

xdist = abs(x(1)-x(2));
ydist = abs(y(1)-y(2));

distPixels = (xdist^2+ydist^2)^0.5

distCM = distPixels*(heart.depthspan/heart.depth);

area = pi*(distCM/2)^2;

disp(area)




disp "end"