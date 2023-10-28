function addborder(topLeftX, topLeftY, bottomRightX, bottomRightY, color)
    if nargin < 5
        error('MATLAB:addborder','ADDBORDER requires four inputs.');
    end
    % top line
    line([topLeftX, bottomRightX], [topLeftY, topLeftY], 'Color', color, 'LineWidth', 2);
    % bottom line
    line([topLeftX, bottomRightX], [bottomRightY, bottomRightY], 'Color', color, 'LineWidth', 2);
    % left line
    line([topLeftX, topLeftX], [topLeftY, bottomRightY], 'Color', color, 'LineWidth', 2);
    % right line
    line([bottomRightX, bottomRightX], [topLeftY, bottomRightY], 'Color', color, 'LineWidth', 2);
end