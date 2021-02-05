function EEG = addMissingChanLocations(EEG,chanLocs)

% only checking one field, the other ones should be automatically filled
theta = {EEG.chanlocs.theta};

missing = find(cellfun(@(v) isempty(v) | isnan(v),theta));

knownChan = {chanLocs.labels};

for iChan = missing
    
    chanLabel = EEG.chanlocs(iChan).labels;
    % index of chanLabel in chanLocs
    iChan0 = find(strcmp(knownChan,chanLabel),1);
    
    if isempty(iChan0)
        % channel iChan does not appear in chanLocs, it is an external
        % channel with no locations (e.g. Sound).
        continue;
    end
    
    % else add location info
    EEG = pop_chanedit(EEG,...
        'changefield',{iChan,'theta',chanLocs(iChan0).theta},...
        'changefield',{iChan,'radius',chanLocs(iChan0).radius},...
        'changefield',{iChan,'X',chanLocs(iChan0).X},...
        'changefield',{iChan,'Y',chanLocs(iChan0).Y},...
        'changefield',{iChan,'Z',chanLocs(iChan0).Z},...
        'changefield',{iChan,'sph_theta',chanLocs(iChan0).sph_theta},...
        'changefield',{iChan,'sph_phi',chanLocs(iChan0).sph_phi},...
        'changefield',{iChan,'sph_radius',chanLocs(iChan0).sph_radius});
    
    % add relevant comments
    EEG = MEEGtools.addComments(EEG,sprintf('Add missing location for channel %s',chanLabel));

end
end
%
%