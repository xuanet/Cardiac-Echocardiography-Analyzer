function y = index2cm(measuredpixels, totalpixels, totallength)
    if nargin < 3
        error('MATLAB:index2cm','INDEX2CM requires three inputs.');
    end
    t = measuredpixels * (totallength / totalpixels);
    y = strcat(string(t), " cm");
end