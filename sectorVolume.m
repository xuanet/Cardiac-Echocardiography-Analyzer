function sv = sectorVolume(left, right, cmPerPixel, numSlice)
    % Each small sector volume (pretend it spans the entire circle)* is (sector radius)^2*pi. *The final answer is
    % divided by the number of slices
    sumLeft = 0;
    sumRight = 0;
    for i = 1:length(left)
        sumLeft = sumLeft + pi*left(i)^2*cmPerPixel;
        sumRight = sumRight + pi*right(i)^2*cmPerPixel;
    end
    sv = (sumLeft+sumRight)/(2*numSlice);
end