%cd('Z:\Lee_Lab\Aaron\data\scanimage\AK001')
mousePath = 'Z:\Lee_Lab\Aaron\data\scanimage\AK001';
sessionList = dir([mousePath '\AK*']);

%% Produce motion corrected movies
for session = 4%:size(sessionList,1)
sessionPath=fullfile(mousePath,sessionList(session).name);
cd(sessionPath);
acq = Acquisition2P([],@SC2Pinit); % Uses Acquision2P class 
%% https://github.com/HarveyLab/Acquisition2P_class
acq.motionCorrect; % Produce motion corrected 
output_dir = fullfile(mousePath, '\sessions\',sessionList(session).name);
if ~exist(output_dir,'dir')
    mkdir(output_dir)
end

%%
%load([sessionList(session).name '_001']);
%eval(['acq = ' sessionList(session).name '_001;'])
channelNum = 1;
%acq.metaDataSI = metaDataSI;
sizeBit = acq.correctedMovies.slice(1).channel(1).size;
sizeArray = repmat(sizeBit,[size(acq.Movies,2) 1]);
for sliceNum = 1:4
acq.correctedMovies.slice(sliceNum).channel(1).siseeze = sizeArray;
acq.indexMovie(sliceNum,channelNum,output_dir);
acq.calcPxCov([],[],[],sliceNum,channelNum,output_dir);
save(fullfile(output_dir,sessionList(session).name),'acq','-v7.3')
end
clear acq
end
%% make sessionList_all variable for each mouse and save 

sessionList_all = cell(size(sessionList,1),1);
for s = 1:size(sessionList,1)
    sessionList_all{s,1} = sessionList(s,1).name;
end