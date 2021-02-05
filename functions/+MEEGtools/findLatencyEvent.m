function iE = findLatencyEvent(EEG, field, targetValue)
% findLatencyStory Return latency (in samples) corresponding to the (first)
% event of type 'targetEvent'
%
if ~isempty(EEG.event)
    iE = find(cellfun(@(x) isequal(x,targetValue),{EEG.event(:).(field)}),1);
else
    iE = [];
end
if ~isempty(iE)
    iE = EEG.event(iE).latency;
end
end
%
%