function y = points2cm(x1, y1, x2, y2, totalpixels, totallength)
    if nargin < 6
        error('MATLAB:index2cm','INDEX2CM requires six inputs.');
    end
    d = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    t = d * (totallength / totalpixels);
    y = strcat(string(t), " cm");
end