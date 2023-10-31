function drawEndocardialBoundary(imageVolume, dimension)
    [~,~,numSlices] = size(imageVolume);
    for sliceNum = 1:numSlices
        currentSlice = imageVolume(:,:,sliceNum);
        
        figure;
        imshow(currentSlice, []);
        title(['Slice ', num2str(sliceNum), ' (Dimension: ', dimension, ')']);
        
        % User draws endocardial boundary here
        h = drawfreehand('Closed', true);
        wait(h);
        
        % drawn boundaries can be stored in a cell array or any other data structure if needed
        % boundaries{sliceNum} = h.Position;
        
        close;
    end
end
