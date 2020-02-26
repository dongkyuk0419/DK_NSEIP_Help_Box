% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Omid Sani, Shanechi Lab, University of Southern California, 2019
%   DongKyu Kim, Shanechi Lab, USC, 2019
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pruneEvents2 Will prune the events struct from Pesaran data and only keep
%the specified trials
%   Inputs:
%     - (1) events: events struct
%     - (2) events: indexes to keep
%   Outputs:
%     - (1) events: pruned events struct
%   Usage example:
%       events = pruneEvents(events, [events.Success] == 1);
% This is a modified version of the pruneEvents because there is a bug.

function events = pruneEvents2(events, isOk)
N_ok = length(isOk);
% Remove trials that were not Ok
fNames = fieldnames(events);
for fi = 1:numel(fNames)
    fVals = events.(fNames{fi});
% Check dimensions of fVals
    fVals_D = size(fVals);
    switch find(fVals_D==N_ok)
        case 1
            if length(fVals_D) < 3
                events.(fNames{fi}) = fVals(isOk,:);
            else
                events.(fNames{fi}) = fVals(isOk,:,:);
            end
        case 2
            if length(fVals_D) < 3
                events.(fNames{fi}) = fVals(:,isOk);
            else
                events.(fNames{fi}) = fVals(isOk,:,:);
            end
    end
end

end
