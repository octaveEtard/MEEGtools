function iE = findLatencyEvent(EEG, field, targetValue)
% findLatencyStory Return latency (in samples) corresponding to the (first)
% event of type 'targetEvent'
%
iE = find(cellfun(@(x) isequal(x,targetValue),{EEG.event(:).(field)}),1);

if ~isempty(iE)
    iE = EEG.event(iE).latency;
end

end
