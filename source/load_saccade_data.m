function [saccade_data] = load_saccade_data(experiment_date,validpathlist)
%LOAD_SACCADE_DATA Summary of this function goes here
%   Detailed explanation goes here
start_i = 999999999;
end_i = 0;
for i = 1:length(validpathlist)
    if (strfind(validpathlist{i},experiment_date))
        if (start_i> i)
            start_i = i;
        end
        if (end_i < i)
            end_i = i;
        end
    end
end
paths = validpathlist(start_i:end_i);
settings.removeConstantSamplesAtTheEnd = true;
Deye = loadRawDataMultiRec(paths,'eye',{},settings);
Dlfp = loadRawDataMultiRec(paths,'clfp',{},settings);
[Deye, ~] = removeEyeTrackerClipping(Deye, struct('events', Deye.info.events, 'keepAreaAroundTargets', 2));
saccade_data = Deye;
saccade_data.eye = Deye.data;
saccade_data.lfp = Dlfp.data;
saccade_data = rmfield(saccade_data,'data');
end

