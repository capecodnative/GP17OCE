function fileStruct = parse_all_headers(dataDir)
    % Initialize an empty struct to store the file data
    fileStruct = struct();
    fileStruct.directory = dataDir;  % Store the directory path in the struct
    
    % Get a list of all .cnv files in the directory
    files = dir(fullfile(dataDir, '*.cnv'));
    numFiles = length(files);
    
    % Display the number of files to be processed
    fprintf('Number of files to process: %d\n', numFiles);
    
    % Initialize a timer to track updates
    lastUpdateTime = tic;
    
    % Loop over each file
    for i = 1:numFiles
        % Get the full path of the current file
        filePath = fullfile(dataDir, files(i).name);
        
        % Provide status update every two seconds
        if toc(lastUpdateTime) > 2
            fprintf('Processing file %d of %d: %s\n', i, numFiles, files(i).name);
            lastUpdateTime = tic;
        end
        
        % Open the file and read line by line
        fid = fopen(filePath, 'r');
        columnNames = {};
        headerLineCount = 0;
        
        while ~feof(fid)
            line = fgetl(fid);
            headerLineCount = headerLineCount + 1;
            % Check for the end of the header
            if startsWith(line, '*END*')
                break;
            end
            % Look for lines beginning with "# name"
            if startsWith(line, '# name')
                % Extract column names (XXX) from lines matching "# name YY = XXX:..."
                % where YY is the column number and may be one or two digits and the first colon ends the name
                parts = strsplit(line, '=');
                if length(parts) >= 2
                    columnName = strtrim(parts{2});
                    columnName = strsplit(columnName, ':');
                    columnNames{end+1} = strtrim(columnName{1});
                end
            end
        end
        
        % Close the file
        fclose(fid);
        
        % Add the file and its columns to the struct
        [~, fileName, ~] = fileparts(files(i).name);
        fileStruct.(fileName).columns = columnNames;
        fileStruct.(fileName).headerLines = headerLineCount;
    end
    
    % Final status update
    fprintf('Processing complete. %d files processed.\n', numFiles);
end
