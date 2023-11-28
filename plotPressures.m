function plotPressures(results, frameRate)
    if nargin < 2
        error('Not enough input arguments');
    end
    numericResults = cell2mat(results);
    time = (2:numel(numericResults) + 1) / frameRate;
    figure;
    plot(time, numericResults(3:end), '-o', 'LineWidth', 2);
    title('Aortic Pressure over Time (mmHg)');
    xlabel('Time from end of diastole (s)');
    ylabel('Pressure');
    grid on;
    grid minor;
end
