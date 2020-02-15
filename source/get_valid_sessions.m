function [validpathlist] = get_valid_sessions(fullpathlist)
%GET_VALID_SESSIONS Summary of this function goes here
%   Detailed explanation goes here

    if exist('D:\Data\validpathlist_LFP_Archie.mat','file')
        validpathlist = load('D:\Data\validpathlist_LFP_Archie.mat');
    else
        validpathlist = {};
        counter = 1;
        setting.removeConstantSamplesAtTheEnd = true;
        for i = 1:length(fullpathlist)
            session = fullpathlist{i};
            lfpdata = loadRawData(session,'clfp',{},setting);
            if isempty(lfpdata.data)
                % this is missing LFP data
            elseif isempty(lfpdata.info.events.Trial)
                % this is missing event data
            else
                validpathlist{counter} = session;
                counter = counter + 1;        
            end    
        end
    end

end

