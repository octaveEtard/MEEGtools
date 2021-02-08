function EEG = replaceChanLocs(EEG,chanLocs)
%
% Replace location information for all channels in EEG by the one in
% chanLocs
nChan = EEG.nbchan;

knownChan = {chanLocs.labels};

for iChan = 1:nChan
    chanLabel = EEG.chanlocs(iChan).labels;
    % index of chanLabel in chanLocs
    iChan0 = find(strcmp(knownChan,chanLabel),1);
    
    if isempty(iChan0)
        % deal with eternal channels with no location?
        error('Could not find location for %s',chanLabel)
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
end

    % add relevant comments
    EEG = MEEGtools.addComments(EEG,'Channel locations changed');

end