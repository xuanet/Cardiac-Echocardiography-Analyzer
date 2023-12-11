function slice = selectSlice(data, range)
    prompt = 'Choose this slice?';
    promptInc = 'Advance how many frames?';
%     breakLoop = false;
    s = 1;
    while (1 <= s) && (s <= range)
        currentSlice = data(:,s,:);
        imgH = squeeze(currentSlice);
        figure(1)
        imshow(imgH', []);
        title(s)
        choice = questdlg(prompt,'Slice Confirmation', 'Yes', 'No', 'Yes');
        if strcmp(choice, 'Yes')
            break
        end
        increment = questdlg(promptInc,'Increment', '+1', '+10', '-1', '-1');
        switch increment
            case '+1'
                s = s+1;
            case '+10'
                s = s+10;
            case '-1'
                s = s-1;
        end
    end

    slice = s;

end
