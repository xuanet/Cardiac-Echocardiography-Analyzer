heart = resampleDicom('002A.dcm');
centerW = floor(heart.width/2);

while (true)
    for t = 1:12
        data = heart.data(centerW,:,:,t);
        imgW = squeeze(data);
        figure(1)
        imshow(imgW', []);
        title(num2str(t));
        pause(0.1);
    
    end
end