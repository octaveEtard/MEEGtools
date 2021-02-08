function iE = findLatencyEvent(EEG, field, targetValue,n)
% findLatencyStory Return latency (in samples) corresponding to the n first
% event of type 'targetEvent'
%

if nargin() < 4
    n = 1; % only first occurence by default
end

if ~isempty(EEG.event)
    iE = find(cellfun(@(x) isequal(x,targetValue),{EEG.event(:).(field)}),n);
else
    iE = [];
end
if ~isempty(iE)
    iE = [EEG.event(iE).latency];
end
end
%
%