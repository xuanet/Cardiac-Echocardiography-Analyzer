function plotPressures(results, frameRate)
    if nargin < 2
        error('Not enough input arguments');
    end

    numPressures = numel(results);
    timePerFrame = 1/frameRate;
    
    time = zeros(1, numPressures);
    for t = 1:numPressures
        time(t) = timePerFrame*(t-1);
    end

    figure;
    plot(time, results, '-o', 'LineWidth', 2);
    title('Aortic Pressure over Time');
    xlabel('Time after end diastole (s)');
    ylabel('Pressure (mmHg)');
    grid on;
    grid minor;
end
