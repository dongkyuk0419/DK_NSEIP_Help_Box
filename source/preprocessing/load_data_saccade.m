function [lfp,eye,events_valid,ind_anchor_points] = load_data_saccade(Data_Path,start_ind,end_ind,smoothing_time_window,varargin)
% load_data_saccade
%   This function extracts valid trials from the start_ind to end_ind.

    numVarargin = length(varargin);
    if(numVarargin == 1)
        end_offset = varargin{1};
    else
        end_offset = 0;
    end

    Loaded = load(Data_Path);
    events = Loaded.Data.info.events;
    % only extract VODR (TaskCode 11).
    [events_valid, ~] = pruneEventsConditional2(events, struct('Success', 1,'TaskCode', 11, 'RewardTask',1), {});

    % Parse start, end indicies
        
    switch start_ind
        case 'StartOn'
            i_begin = events_valid.StartOn;
        case 'TargsOn'
            i_begin = events_valid.TargsOn;
    end
    switch end_ind
        case 'End'
            i_end = events_valid.End;
            if start_ind == 'StartOn'
                anchor_points = [events_valid.StartOn, events_valid.TargsOn, events_valid.Go, events_valid.TargAq, events_valid.End];
            elseif start_ind == 'TargsOn'
                anchor_points = [events_valid.TargsOn, events_valid.Go, events_valid.TargAq, events_valid.End];
            end
    end
    
    i_end = i_end + end_offset;
    if end_offset ~= 0
        anchor_points = [anchor_points, i_end];
    end
    
    % Extract LFP
    N = length(i_begin);
    lfp = cell(N,1);
    eye = cell(N,1);
    for i = 1:N
        ind_begin = find(Loaded.Data.time >= i_begin(i)/1000,1)-smoothing_time_window+1;
        ind_end = find(Loaded.Data.time >= i_end(i)/1000,1);
        lfp{i} = Loaded.Data.lfp(ind_begin:ind_end,:);
        eye{i} = Loaded.Data.eye(ind_begin:ind_end,:);
    end
    
    % Define anchor point indices
    ind_anchor_points = zeros(size(anchor_points));
    for i = 1:N
        temp = zeros(size(anchor_points,2),1);
        for ii = 1:length(temp)
            temp(ii) = find(Loaded.Data.time >= anchor_points(i,ii)/1000,1);
        end
        temp = temp - temp(1) + 1;
        ind_anchor_points(i,:) = temp;
        clear temp
    end
end

