function AUC_report(folderDir)
%% Input Currents

% which number run does each current correspond to
% chronological order please

%% File set up
set(0,'DefaultFigureWindowStyle','docked')

d = struct2cell(dir([fullfile(folderDir),'/*.mca']));
nameList = d(1,:);

file_count = numel(nameList);

%% Information on peaks of interest

peaksOI = [315 917 1016 1265 1413]; % IN CHANNEL NUMBER

AUCallfiles = [];
AUCerrors = [];
realtimes = [];
livetimes = [];
datetimes = [];

%% Pull Count Rates for Peaks Of Interest
for i=1:file_count
    %clf
    figure('Name',string(nameList(i)));
    file = string(fullfile(folderDir, nameList(i)));
    spectrum = readmca(file);
%% proceed
    [AUC, AUCerrorSingle, realtimeSingle, livetimeSingle] = get_AUC(spectrum,peaksOI);

    AUCallfiles = [AUCallfiles ; AUC];
    AUCerrors = [AUCerrors ; AUCerrorSingle];
    realtimes = [realtimes; realtimeSingle];
    livetimes = [livetimes; livetimeSingle];
    datetimes = [datetimes ; spectrum.time];
    title(nameList(i));
end
grid on
%% Continuing Analysis
dataTable = AUCallfiles(:,:);

fileName = nameList;

%% Formatting Output
splitDir = split(folderDir,{'\' '/'});
properFileName = [splitDir{end,1} '_aucPIXERep.xlsx'];
file = string(fullfile(folderDir, properFileName));
header = ["Filename" "real(s)" "live(s)" "datetime" string(peaksOI)];
if isrow(fileName)
    fileName = fileName';
end
writematrix(header,file,'Sheet',1,'Range','A1');
writecell(fileName,file,'Sheet',1,'Range','A2');
writematrix(realtimes,file,'Sheet',1,'Range','B2');
writematrix(livetimes,file,'Sheet',1,'Range','C2');
writematrix(datetimes,file,'Sheet',1,'Range','D2');
writematrix(dataTable,file,'Sheet',1,'Range','E2');

writematrix(["file name" string(peaksOI)],file,'Sheet',2,'Range','D1');
writecell(fileName,file,'Sheet',2,'Range','D2');
writematrix(AUCerrors,file,'Sheet',2,'Range','E2');

end