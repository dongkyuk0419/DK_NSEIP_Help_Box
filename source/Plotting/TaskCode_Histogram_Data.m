function [TC,N] = TaskCode_Histogram(events)
%TASKCODE_HISTOGRAM Summary of this function goes here
%   Detailed explanation goes here
[TC] = unique(events.TaskCode);
N = zeros(size(TC));
for i = 1:length(TC)
    N(i) = sum(events.TaskCode==TC(i));
end

end

