% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Omid Sani, Shanechi Lab, University of Southern California, 2019
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pruneEventsConditional Will prune the events struct from Pesaran data and 
%only keep trials satisfying some conditions
%   Inputs:
%     - (1) events: events struct
%     - (2) isMemberConditions: fields to make sure are equal to some
%               value, or their value is among a set of numbers
%     - (3) isNotMemberConditions: fields to make sure are not equal to 
%               some value, or their value is not among a set of numbers
%   Outputs:
%     - (1) events: pruned events struct
%     - (2) isOk: index of kept trials
%   Usage example:
%       events = pruneEventsConditional(events, struct('Success', 1, 'TaskCode', [11, 16], 'RewardTask', 1));

function [events, isOk] = pruneEventsConditional2(events, isMemberConditions, isNotMemberConditions)

if nargin < 2, isMemberConditions = struct; end
if nargin < 3, isNotMemberConditions = struct; end

if isempty(isMemberConditions), isMemberConditions = struct; end
if isempty(isNotMemberConditions), isNotMemberConditions = struct; end

eFNames = fieldnames(events);
isOk = true(numel(events.(eFNames{1})), 1);

% Check isMemberConditions conditions
fNames = fieldnames(isMemberConditions);
for fi = 1:numel(fNames)
    values = events.(fNames{fi});
    okValues = isMemberConditions.(fNames{fi});
    isOk = isOk & arrayfun(@(i)(  ismember(values(i), okValues)  ), (1:numel(isOk))');
end

% Check isNotMemberConditions conditions
fNames = fieldnames(isNotMemberConditions);
for fi = 1:numel(fNames)
    values = events.(fNames{fi});
    okValues = isNotMemberConditions.(fNames{fi});
    isOk = isOk & arrayfun(@(i)( ~ismember(values(i), okValues)  ), (1:numel(isOk))');
end

events = pruneEvents2(events, isOk);

end
