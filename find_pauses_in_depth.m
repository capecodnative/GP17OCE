function [pauses, counts, maxDepth] = find_pauses_in_depth(depthData, minDistanceBetweenPauses, numPumps)
    % Filter for depth data greater than 5
    depthData = depthData(depthData > 5);
    % Bin the data into 1m bins
    [N, edges] = histcounts(depthData, 0:1:max(depthData));
    % Find the peaks in the histogram and sort them in descending order
    [~, locs] = findpeaks(N, 'MinPeakDistance', minDistanceBetweenPauses, 'SortStr', 'descend');
    % Take the first numPumps
    locs = locs(1:numPumps);
    % Convert the bin edges to the depth values
    pauses = edges(locs);
    % Return the histogram counts
    counts = N(locs);
    % Return the maxDepth as the bottom depth (the most frequent bin)
    maxDepth = max(pauses);
end