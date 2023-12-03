close all

heart = resampleDicom('002A.dcm');
centerW = floor(heart.width/2);
% centerW = 100;

data = heart.data(:,:,:,2);
data = squeeze(data);


for frame = 80:heart.width
    slice = data(:,frame,:);
    extract = squeeze(slice);
    figure(1)
    imshow(extract', []);
    title(num2str(frame));
    pause(0.2)
end

