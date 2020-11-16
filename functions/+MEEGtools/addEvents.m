function EEG = addEvents(EEG,sampleIndex,type,code)
% Add events to EEG structure at 'latency' (sample *index*) sampleIndex.
% 'type' and 'code' can be strings (if numel(sampleIndex) == 1) or cell
% arrays for multiple events.
%
nPreviousEvents = length(EEG.event); % nb of events previously in EEG
eventDur = 1 / EEG.srate;
% eventFields = fields(EEG.event);

nEvents = numel(sampleIndex);

[type,code] = putInCell(type,code);

for iEvent = 1:nEvents
    EEG.event(nPreviousEvents + iEvent).latency = sampleIndex(iEvent);
    EEG.event(nPreviousEvents + iEvent).duration = eventDur;
    EEG.event(nPreviousEvents + iEvent).type = type{iEvent};
    EEG.event(nPreviousEvents + iEvent).code = code{iEvent};
    EEG.event(nPreviousEvents + iEvent).urevent = nPreviousEvents + iEvent;
    
    % unused fields
    % EEG.event(nPreviousEvents + iEvent).channel = 0;
    % EEG.event(nPreviousEvents + iEvent).bvtime = 0;
    % EEG.event(nPreviousEvents + iEvent).bvmknum = 0;
end

EEG.urevent = rmfield(EEG.event,'urevent');
EEG = eeg_checkset(EEG);

end
%
%