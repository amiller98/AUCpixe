function mcadat = readmca(fname)
    data = struct;
%% 
    oneline = fileread(fname); % import as character vector
    multiline =  transpose(strsplit(oneline, "\n")); % split by \n
    liveTimeIdx = find(contains(multiline,'LIVE_TIME'));
    realTimeIdx = find(contains(multiline,'REAL_TIME'));
    dataStartIdx = find(contains(multiline,'<<DATA>>'));
    dataEndIdx = find(contains(multiline,'<<END>>'));
    dateTimeIdx = find(contains(multiline,'START_TIME'));


    tempArray = strsplit(strip(multiline{liveTimeIdx})," ");
    data.livetime = str2double(tempArray{end});

    tempArray = strsplit(strip(multiline{realTimeIdx})," ");
    data.realtime = str2double(tempArray{end});

    tempArray = strsplit(strip(multiline{dateTimeIdx})," ");
    datestring = string([tempArray{end-1} ' ' tempArray{end}]);
    data.time = datetime(datestring,'InputFormat','MM/dd/yyyy HH:mm:ss');


    countTemp = multiline(dataStartIdx+1:dataEndIdx-1,1);
    data.counts = str2double(countTemp);
    data.channels = length(data.counts);
       
    mcadat = data;
end

