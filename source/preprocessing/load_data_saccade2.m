function [data_this,eye_this,events_valid,re_eve] = load_data_saccade2(Data_Path,varargin)
%LOAD_DATA_SACCADE Summary of this function goes here
% this is obsolete
numVarargin = length(varargin);
if(numVarargin == 2)
    mode = varargin{1};
    window_size = varargin{2};
elseif(numVarargin == 1)
    mode = varargin{1};
    window_size = 1;
else
    mode = 0;
    window_size = 1;
end
    Loaded = load(Data_Path);
    events = Loaded.Data.info.events;
    [events_valid, ~] = pruneEventsConditional2(events, struct('Success', 1,'TaskCode', 11, 'RewardTask',1), {});
    T_to = events_valid.TargsOn;
    T_ta = events_valid.TargAq;
    T_ed = events_valid.End;
    T_stt = events_valid.StartTrial; % For anchoring
    T_ss = events_valid.SaccStart;
    T_go = events_valid.Go;
    T_so = events_valid.StartOn;
    MT_stt_ta = max(T_ta - T_stt);
    i_begin = T_ta - MT_stt_ta;
    range = max(T_ed - T_ta) + MT_stt_ta+1500;
    N = length(i_begin);
    index_of_interest = zeros(N,1);
    data_of_interest = zeros(N,range+1,32);
    eye_of_interest = zeros(N,range+1,2);
    for i = 1:N
        index_of_interest(i) = find(Loaded.Data.time >= i_begin(i)/1000,1); 
        data_of_interest(i,:,:) = Loaded.Data.lfp(index_of_interest(i):index_of_interest(i)+range,:);
        eye_of_interest(i,:,:) = Loaded.Data.eye(index_of_interest(i):index_of_interest(i)+range,:);
    end
% Extract "Chosen" Data [Target On ~ End]
    index_ta = MT_stt_ta+1;
    T_to_ta = mean(T_ta-T_to);
    T_ta_ed = mean(T_ed-T_ta);
    T_ta_ss = mean(T_ta-T_ss);
    T_ta_go = mean(T_ta-T_go);
    T_so_ta = -mean(T_so-T_ta);
    index_to = round(index_ta-T_to_ta);
    index_end = round(index_ta+T_ta_ed);
    index_ss = round(index_ta-T_ta_ss);
    index_go = round(index_ta-T_ta_go);
    index_so = round(index_ta - T_so_ta);
    % Two lines below control the window.
    if mode == 0
        start_ind = index_to - window_size + 1; % this might not be optimal.
        end_ind = index_end;
    elseif mode == 1
        start_ind = index_go-100;
        end_ind = index_end;
    elseif mode == 2
        start_ind = index_go-100;
        end_ind = index_end-200;
    elseif mode == 3
        start_ind = index_go - 50;
        end_ind = index_end;
    elseif mode == 4
        start_ind = index_ta;
        end_ind = index_end;
    elseif mode == 5
        start_ind = index_so;
        end_ind = index_end;
    elseif mode == 6
        start_ind = index_go;
        end_ind = index_end;
    end
    data_this = data_of_interest(:,start_ind:end_ind,:);
    eye_this = eye_of_interest(:,start_ind:end_ind,:);
    re_eve.go = index_go-start_ind;
    re_eve.ta = index_ta - start_ind;
    re_eve.ss = index_ss-start_ind;
    re_eve.to = index_to-start_ind;
    re_eve.so = index_to-start_ind;
end

