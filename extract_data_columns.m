function data = extract_data_columns(fileStruct, varargin)
    % Initialize an empty struct to store the extracted data
    data = struct();
    
    % Determine which columns to extract
    columnsToExtract = varargin;
    
    % Get the directory from the fileStruct
    dataDir = fileStruct.directory;
    
    % Get the list of file names (excluding 'directory')
    fileNames = fieldnames(fileStruct);
    fileNames = fileNames(~strcmp(fileNames, 'directory')); % Exclude 'directory' field
    numFiles = length(fileNames);
    
    % Display the number of files to be processed
    fprintf('Number of files to process: %d\n', numFiles);
    
    % Initialize a timer to track updates
    lastUpdateTime = tic;
    
    % Loop over each file in the struct
    for i = 1:numFiles
        fileName = fileNames{i};
        columnNames = fileStruct.(fileName).columns;
        headerLines = fileStruct.(fileName).headerLines;
        
        % Provide status update every two seconds
        if toc(lastUpdateTime) > 2
            fprintf('Processing file %d of %d: %s\n', i, numFiles, fileName);
            lastUpdateTime = tic;
        end
        
        % Use dlmread to efficiently read data after the header lines
        filePath = fullfile(dataDir, [fileName, '.cnv']);
        dataMatrix = dlmread(filePath, '', headerLines, 0);
        
        % Extract the relevant columns and store in the struct
        if ischar(columnsToExtract{1}) && strcmpi(columnsToExtract{1}, 'all')
            % Extract all columns
            data.(fileName).data = dataMatrix;
            data.(fileName).variableNames = columnNames;
        else
            % Extract only the specified columns
            columnIndices = find(ismember(columnNames, columnsToExtract));
            data.(fileName).data = dataMatrix(:, columnIndices);
            data.(fileName).variableNames = columnNames(columnIndices);
        end
    end
    
    % Final status update
    fprintf('Data extraction complete. %d files processed.\n', numFiles);
end
