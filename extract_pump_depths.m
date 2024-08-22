function pumpData = extract_pump_depths(dataStruct, depthVarName, minDistanceBetweenPauses, numPumps)
    % Initialize a struct to store pump data
    pumpData = struct();
    
    % Loop over each file in the dataStruct
    fileNames = fieldnames(dataStruct);

    % Create a figure for showing the pauses
    figure;
    
    for i = 1:length(fileNames)
        fileName = fileNames{i};
        
        % Extract depth data
        depthData = dataStruct.(fileName).data(:, ismember(dataStruct.(fileName).variableNames, depthVarName));
        
        % Identify pauses where the depth remains relatively constant
        [pauses, counts, maxDepth] = find_pauses_in_depth(depthData, minDistanceBetweenPauses, numPumps);

        % Plot the depth data with identified pauses as lines
        plot(depthData, 'b');
        hold on;
        for j = 1:length(pauses)
            plot([1, length(depthData)], [pauses(j), pauses(j)], 'r--');
            % Calculate the padding width
            padding = (-1)^j * 0.05 * length(depthData);
            % Calculate the text position
            textPosition = pauses(j);
            % Add the text
            text(padding + length(depthData)/2, textPosition, num2str(pauses(j) - maxDepth), 'HorizontalAlignment', 'center',...
            'FontSize',10);
        end
        xlabel('Sample Number');
        % Title the plot with the file name
        title(fileName);
        % Save the plot to the /plots subdirectory with the filename as a png
        saveas(gcf, ['plots/', fileName, '.png']);
        % Pause
        %pause;
        % Clear the plot
        clf;

        % Store the identified pump data in the struct
        pumpData.(fileName).pauses = pauses;
        pumpData.(fileName).pumpDepths = pauses - maxDepth;
        pumpData.(fileName).counts = counts;
        pumpData.(fileName).maxDepth = maxDepth;
    end
    % Close the figure
    close;
end
