function y = linemaker(x1, y1, x2, y2)
    if nargin < 4
        error('MATLAB:index2cm','INDEX2CM requires four inputs.');
    end
    line([x1 x2], [y1 y2],'Color','red','LineWidth',2)
end