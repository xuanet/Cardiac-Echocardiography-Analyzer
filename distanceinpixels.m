function y = distanceinpixels(x1, y1, x2, y2)
    if nargin < 4
        error('MATLAB:index2cm','INDEX2CM requires four inputs.');
    end
    d = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    y = d;
end